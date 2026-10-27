#!/usr/bin/env python3
"""Guest-side Chromium screen capture check; see docs/vm-screencast-test.md."""

import argparse
import base64
import http.server
import json
import os
import pathlib
import shutil
import subprocess
import tempfile
import threading
import time
import urllib.request

from websockets.sync.client import connect

HTML = b"""<!doctype html><meta charset="utf-8"><title>VM portal screen-share test</title>
<style>body{color:white;font:28px sans-serif;background:#163d70}video{width:600px;border:3px solid white}</style>
<h1>xdg-desktop-portal-wlr: live screen test</h1><p id="clock"></p><video id="v" autoplay muted></video>
<script>setInterval(()=>{document.querySelector('#clock').textContent=new Date().toISOString();
document.body.style.backgroundColor=`hsl(${Date.now()/30%360},60%,30%)`},100);</script>"""


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/html")
        self.end_headers()
        self.wfile.write(HTML)

    def log_message(self, format: str, *args: object) -> None:
        pass


parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument(
    "--manual-picker",
    action="store_true",
    help="select the monitor and confirm Share manually (120-second timeout)",
)
args = parser.parse_args()

chromium = shutil.which("chromium")
if not chromium:
    parser.error("chromium is not on PATH; run as the graphical session user")
if not args.manual_picker:
    outputs = json.loads(
        subprocess.check_output(["swaymsg", "-t", "get_outputs", "-r"], text=True)
    )
    active = [output for output in outputs if output["active"]]
    if len(active) != 1 or active[0]["rect"] != {
        "x": 0,
        "y": 0,
        "width": 1280,
        "height": 800,
    }:
        parser.error(
            "automatic selection requires one 1280x800 output at (0, 0); use --manual-picker"
        )
    if (
        subprocess.run(
            ["pgrep", "-u", str(os.getuid()), "-x", "slurp"],
            capture_output=True,
            check=False,
        ).returncode
        == 0
    ):
        parser.error("another slurp chooser is already running")

artifacts = pathlib.Path(tempfile.mkdtemp(prefix="vm-screencast-test-"))
print("ARTIFACTS", artifacts, flush=True)
server = http.server.HTTPServer(("127.0.0.1", 0), Handler)
threading.Thread(target=server.serve_forever, daemon=True).start()
profile = str(artifacts / "chromium-profile")
log = (artifacts / "chromium.log").open("w")
browser = subprocess.Popen(
    [
        chromium,
        "--user-data-dir=" + profile,
        "--no-first-run",
        "--no-default-browser-check",
        "--password-store=basic",
        "--ozone-platform=wayland",
        "--remote-debugging-port=0",
        "--remote-debugging-address=127.0.0.1",
        "--remote-allow-origins=http://localhost",
        "--disable-session-crashed-bubble",
        "http://127.0.0.1:" + str(server.server_port),
    ],
    stdout=log,
    stderr=log,
)
ws = None
seq = 0


def cdp(method, params=None):
    global seq
    if ws is None:
        raise RuntimeError("Chromium debugging connection is not open")
    seq += 1
    msg_id = seq
    ws.send(json.dumps({"id": msg_id, "method": method, "params": params or {}}))
    while True:
        reply = json.loads(ws.recv(timeout=20))
        if reply.get("id") == msg_id:
            if "error" in reply:
                raise RuntimeError(reply)
            return reply.get("result", {})


def evaluate(js, await_promise=False):
    result = cdp(
        "Runtime.evaluate",
        {
            "expression": js,
            "returnByValue": True,
            "userGesture": True,
            "awaitPromise": await_promise,
        },
    )
    if "exceptionDetails" in result:
        raise RuntimeError(result)
    return result.get("result", {}).get("value")


try:
    for _ in range(60):
        try:
            port = (
                (pathlib.Path(profile) / "DevToolsActivePort")
                .read_text()
                .splitlines()[0]
            )
            with urllib.request.urlopen(
                "http://127.0.0.1:" + port + "/json/list", timeout=1
            ) as response:
                pages = json.load(response)
            page = next(p for p in pages if p["type"] == "page")
            break
        except (OSError, ValueError, IndexError, StopIteration):
            if browser.poll() is not None:
                raise RuntimeError(f"Chromium exited; see {artifacts / 'chromium.log'}")
            time.sleep(0.5)
    else:
        raise RuntimeError("No Chromium debugging endpoint")
    ws = connect(page["webSocketDebuggerUrl"], origin="http://localhost")
    time.sleep(2)
    print("BROWSER", evaluate("navigator.userAgent"), flush=True)
    print(
        "GET_DISPLAY_MEDIA",
        evaluate("""(() => {
      window.testState = {status:'pending'};
      navigator.mediaDevices.getDisplayMedia({video:true,audio:false}).then(async stream => {
        window.testStream=stream;
        const video=document.querySelector('video'); video.srcObject=stream; await video.play();
        window.testState={status:'playing',settings:stream.getVideoTracks()[0].getSettings()};
        window.frameCount=0;
        const frame=()=>{window.frameCount++;video.requestVideoFrameCallback(frame)};
        video.requestVideoFrameCallback(frame);
      }).catch(e=>window.testState={status:'error',name:e.name,message:e.message});
      return {secureContext:window.isSecureContext,api:typeof navigator.mediaDevices.getDisplayMedia};
    })()"""),
        flush=True,
    )
    selected = False
    if args.manual_picker:
        print(
            "Select Entire Screen, choose a monitor in the portal, then confirm Share.",
            flush=True,
        )
    for i in range(240 if args.manual_picker else 80):
        state = evaluate("window.testState")
        if state and state.get("status") != "pending":
            print("STREAM", json.dumps(state), flush=True)
            break
        # Native Chromium dialog coordinates for the default 1280x800 VM desktop.
        if not args.manual_picker and (i == 3 or (i == 10 and selected)):
            x, y = {3: (825, 240), 10: (880, 690)}[i]
            for command in [
                f"seat seat0 cursor set {x} {y}",
                "seat seat0 cursor press button1",
                "seat seat0 cursor release button1",
            ]:
                subprocess.run(["swaymsg", command], check=True, capture_output=True)
            print("CHROMIUM_PICKER click", x, y, flush=True)
        slurp = subprocess.run(
            ["pgrep", "-u", str(os.getuid()), "-x", "slurp"],
            capture_output=True,
            check=False,
        )
        if not args.manual_picker and slurp.returncode == 0 and not selected:
            time.sleep(1)
            for command in [
                "seat seat0 cursor set 640 400",
                "seat seat0 cursor press button1",
                "seat seat0 cursor release button1",
            ]:
                subprocess.run(["swaymsg", command], check=True, capture_output=True)
            selected = True
            print("PORTAL_CHOOSER selected monitor", flush=True)
        if i in (15, 40):
            shot = cdp("Page.captureScreenshot", {"format": "png"})
            (artifacts / f"browser-{i}.png").write_bytes(base64.b64decode(shot["data"]))
            subprocess.run(["grim", str(artifacts / f"desktop-{i}.png")], check=False)
            print("WAITING", i, flush=True)
        time.sleep(0.5)
    else:
        raise RuntimeError(
            f"Screen sharing did not start; see screenshots and logs in {artifacts}"
        )
    if state["status"] != "playing":
        raise RuntimeError(state)
    if state["settings"].get("displaySurface") != "monitor":
        raise RuntimeError("Expected a monitor capture, not a browser tab or window")
    print(
        "PIPEWIRE_NODES",
        subprocess.check_output(["pw-dump"], text=True).count(
            '"type": "PipeWire:Interface:Node"'
        ),
        flush=True,
    )
    measurements = []
    for _ in range(4):
        time.sleep(1)
        measurements.append(
            evaluate("""(() => {
          const v=document.querySelector('video'), c=document.createElement('canvas');
          c.width=64;c.height=40; const x=c.getContext('2d');x.drawImage(v,0,0,64,40);
          const d=x.getImageData(0,0,64,40).data;
          let nonblack=0,sum=0;for(let i=0;i<d.length;i+=4){sum+=d[i]+d[i+1]+d[i+2];if(d[i]+d[i+1]+d[i+2]>15)nonblack++}
          return {frames:window.frameCount,width:v.videoWidth,height:v.videoHeight,
            currentTime:v.currentTime,nonblackPixels:nonblack,pixelSum:sum,
            readyState:window.testStream.getVideoTracks()[0].readyState};
        })()""")
        )
    print("FRAME_MEASUREMENTS", json.dumps(measurements), flush=True)
    if measurements[-1]["frames"] <= measurements[0]["frames"]:
        raise RuntimeError("Frame counter is not advancing")
    if not all(
        m["width"] > 0
        and m["height"] > 0
        and m["nonblackPixels"] > 0
        and m["readyState"] == "live"
        for m in measurements
    ):
        raise RuntimeError("Invalid, black or ended video frames")
    if len({m["pixelSum"] for m in measurements}) <= 1:
        raise RuntimeError("Image does not change")
    evaluate("window.testStream.getTracks().forEach(t=>t.stop())")
    print(
        "RESULT PASS: portal stream delivers changing, non-black video frames",
        flush=True,
    )
finally:
    if ws:
        ws.close()
    browser.terminate()
    try:
        browser.wait(timeout=10)
    except subprocess.TimeoutExpired:
        browser.kill()
        browser.wait(timeout=5)
    server.shutdown()
    server.server_close()
    log.close()
    shutil.rmtree(profile, ignore_errors=True)
