#!/usr/bin/env python3
"""Check Firefox monitor capture in a Sway session; see docs/vm-firefox-screencast-test.md."""

import argparse
import contextlib
import http.server
import itertools
import json
import os
import pathlib
import queue
import shutil
import signal
import subprocess
import tempfile
import threading
import time
from typing import cast

HTML = b"""<!doctype html><meta charset="utf-8"><title>Firefox portal screen-share test</title>
<style>
body{color:white;font:28px sans-serif;background:#163d70}
video{width:600px;border:3px solid white}
button{position:fixed;inset:0;font:40px sans-serif}
</style>
<h1>Firefox / xdg-desktop-portal-wlr</h1><p id="clock"></p><video autoplay muted></video>
<button>Click to test monitor sharing</button>
<script>
const report = data => fetch('/report', {method:'POST',body:JSON.stringify(data)});
report({status:'loaded',browser:navigator.userAgent,secureContext:isSecureContext});
setInterval(() => {
  document.querySelector('#clock').textContent = new Date().toISOString();
  document.body.style.backgroundColor = `hsl(${Date.now()/30%360},60%,30%)`;
}, 100);
document.querySelector('button').onclick = async event => {
  event.target.remove();
  report({status:'pending'});
  let stage = 'getDisplayMedia';
  try {
    const stream = await navigator.mediaDevices.getDisplayMedia({video:true,audio:false});
    const track = stream.getVideoTracks()[0];
    report({status:'stream-created',settings:track.getSettings()});
    stage = 'video playback';
    const video = document.querySelector('video');
    video.muted = true;
    video.srcObject = stream;
    await video.play();
    report({status:'playing'});
    let frames = 0;
    const frame = () => { frames++; video.requestVideoFrameCallback(frame); };
    video.requestVideoFrameCallback(frame);
    setInterval(() => {
      try {
        const canvas = document.createElement('canvas');
        canvas.width = 64; canvas.height = 40;
        const context = canvas.getContext('2d');
        context.drawImage(video,0,0,64,40);
        const data = context.getImageData(0,0,64,40).data;
        let nonblack = 0, sum = 0, hash = 2166136261;
        for (let i=0; i<data.length; i+=4) {
          const rgb = data[i]+data[i+1]+data[i+2];
          sum += rgb;
          if (rgb>15) nonblack++;
        }
        for (const byte of data) hash = Math.imul(hash ^ byte, 16777619);
        report({status:'frame',frames,width:video.videoWidth,height:video.videoHeight,
          currentTime:video.currentTime,nonblackPixels:nonblack,pixelSum:sum,
          pixelHash:hash>>>0,readyState:track.readyState});
      } catch (error) {
        report({status:'error',stage:'frame sampling',name:error.name,message:error.message});
      }
    }, 1000);
  } catch (error) {
    report({status:'error',stage,name:error.name,message:error.message});
  }
};
</script>"""


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/":
            self.send_error(404)
            return
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.end_headers()
        self.wfile.write(HTML)

    def do_POST(self):
        if self.path != "/report":
            self.send_error(404)
            return
        try:
            length = int(self.headers.get("Content-Length", "0"))
            if not 0 < length <= 65536:
                raise ValueError("Invalid report length")
            report = json.loads(self.rfile.read(length))
            if not isinstance(report, dict) or not isinstance(
                report.get("status"), str
            ):
                raise TypeError("Invalid report")
            cast(ReportServer, self.server).reports.put_nowait(report)
        except (ValueError, TypeError, queue.Full):
            self.send_error(400)
            return
        self.send_response(204)
        self.end_headers()

    def log_message(self, format: str, *args: object) -> None:
        pass


class ReportServer(http.server.ThreadingHTTPServer):
    def __init__(self):
        self.reports = queue.Queue(maxsize=128)
        super().__init__(("127.0.0.1", 0), Handler)


def validate_stream(settings):
    if settings.get("displaySurface") != "monitor":
        raise RuntimeError("Expected monitor capture, not a browser tab or window")


def validate_frames(measurements):
    if len(measurements) < 4:
        raise RuntimeError("Expected at least four video samples")
    if not all(
        sample["width"] > 0
        and sample["height"] > 0
        and sample["nonblackPixels"] > 0
        and sample["readyState"] == "live"
        for sample in measurements
    ):
        raise RuntimeError("Invalid, black or ended video frames")
    if not all(
        b["frames"] > a["frames"] and b["currentTime"] > a["currentTime"]
        for a, b in itertools.pairwise(measurements)
    ):
        raise RuntimeError("Received video is not advancing")
    if not all(
        b["pixelHash"] != a["pixelHash"] for a, b in itertools.pairwise(measurements)
    ):
        raise RuntimeError("Received image freezes between samples")


def click(x, y):
    for command in (
        f"seat seat0 cursor set {x} {y}",
        "seat seat0 cursor press button1",
        "seat seat0 cursor release button1",
    ):
        reply = json.loads(
            subprocess.check_output(["swaymsg", "-r", command], text=True)
        )
        if not all(item.get("success") for item in reply):
            raise RuntimeError(f"Sway rejected pointer command: {reply}")


def chooser_running():
    return (
        subprocess.run(
            ["pgrep", "-u", str(os.getuid()), "-x", "slurp"],
            capture_output=True,
            check=False,
        ).returncode
        == 0
    )


def check_desktop():
    outputs = json.loads(
        subprocess.check_output(["swaymsg", "-t", "get_outputs", "-r"], text=True)
    )
    active = [output for output in outputs if output["active"]]
    if (
        len(active) != 1
        or active[0]["rect"] != {"x": 0, "y": 0, "width": 1280, "height": 800}
        or active[0].get("scale", 1) != 1
        or not active[0].get("power", True)
    ):
        raise RuntimeError(
            "Automatic selection requires one powered-on 1280x800 output at (0, 0), scale 1; use --manual-picker"
        )
    if chooser_running():
        raise RuntimeError("Another slurp chooser is already running")


def stop_browser(browser):
    # Firefox content processes belong to this newly created process group too.
    with contextlib.suppress(ProcessLookupError):
        os.killpg(browser.pid, signal.SIGTERM)
    try:
        browser.wait(timeout=5)
    except subprocess.TimeoutExpired:
        with contextlib.suppress(ProcessLookupError):
            os.killpg(browser.pid, signal.SIGKILL)
        browser.wait(timeout=5)


def diagnostics(artifacts):
    for filename, command in (
        ("diagnostics.log", ["grim", str(artifacts / "desktop.png")]),
        (
            "portal.log",
            [
                "journalctl",
                "--user",
                "-b",
                "--no-pager",
                "-n",
                "100",
                "-u",
                "xdg-desktop-portal",
                "-u",
                "xdg-desktop-portal-wlr",
            ],
        ),
    ):
        try:
            # Do not let a diagnostic failure hide the original test error.
            with (artifacts / filename).open("w") as log:
                subprocess.run(command, stdout=log, stderr=log, timeout=10, check=False)
        except (OSError, subprocess.SubprocessError) as error:
            print(f"DIAGNOSTIC WARNING: {error}", flush=True)


def run_test(manual, artifacts, result):
    firefox = shutil.which("firefox")
    if not firefox:
        raise RuntimeError("firefox is not on PATH; run as the graphical session user")
    if not manual:
        check_desktop()
    with contextlib.ExitStack() as cleanup:
        profile = pathlib.Path(
            cleanup.enter_context(
                tempfile.TemporaryDirectory(prefix="profile-", dir=artifacts)
            )
        )
        # Match the configured profile's classic UI; do not bypass capture permissions.
        (
            profile / "user.js"
        ).write_text("""user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.nova.enabled", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("datareporting.policy.dataSubmissionEnabled", false);
""")
        log = cleanup.enter_context((artifacts / "firefox.log").open("w"))
        server = ReportServer()
        cleanup.callback(server.server_close)
        threading.Thread(target=server.serve_forever, daemon=True).start()
        cleanup.callback(server.shutdown)
        browser = subprocess.Popen(
            [
                firefox,
                "--no-remote",
                "--profile",
                str(profile),
                f"http://127.0.0.1:{server.server_port}/",
            ],
            stdout=log,
            stderr=log,
            start_new_session=True,
            env={**os.environ, "MOZ_ENABLE_WAYLAND": "1"},
        )
        cleanup.callback(stop_browser, browser)

        def capture_failure(exc_type, _error, _traceback):
            if exc_type is not None:
                diagnostics(artifacts)
            return False

        # Capture the permission/chooser UI before closing the test browser.
        cleanup.push(capture_failure)
        if manual:
            print(
                "Click the test page, select the operating-system screen picker, allow sharing and choose a monitor.",
                flush=True,
            )
        deadline = time.monotonic() + (120 if manual else 60)
        loaded_at = pending_at = None
        started = allowed = selected = playing = False
        while time.monotonic() < deadline:
            if browser.poll() is not None:
                raise RuntimeError(
                    "Firefox exited before capture completed; see firefox.log"
                )
            try:
                event = server.reports.get(timeout=0.2)
            except queue.Empty:
                event = None
            if event:
                result["events"].append(event)
                print("REPORT", json.dumps(event), flush=True)
                status = event["status"]
                if status == "error":
                    raise RuntimeError(
                        f"{event.get('stage')}: {event.get('name')}: {event.get('message')}"
                    )
                if status == "loaded":
                    if not event.get("secureContext"):
                        raise RuntimeError("The test page is not a secure context")
                    loaded_at = time.monotonic()
                elif status == "pending":
                    pending_at = time.monotonic()
                elif status == "stream-created":
                    validate_stream(event["settings"])
                    result["settings"] = event["settings"]
                elif status == "playing":
                    playing = True
                elif status == "frame":
                    result["measurements"].append(event)
                    if len(result["measurements"]) >= 4:
                        if not playing or "settings" not in result:
                            raise RuntimeError("No confirmed monitor stream")
                        validate_frames(result["measurements"])
                        return
            if not manual:
                now = time.monotonic()
                if loaded_at is not None and not started and now - loaded_at >= 1:
                    click(640, 400)
                    started = True
                # Coordinates of Allow in Firefox's classic English UI on the VM.
                if pending_at is not None and not allowed and now - pending_at >= 2:
                    click(720, 265)
                    allowed = True
                    print("FIREFOX_PICKER clicked Allow", flush=True)
                if allowed and not selected and chooser_running():
                    time.sleep(0.5)
                    click(640, 400)
                    selected = True
                    print("PORTAL_CHOOSER selected monitor", flush=True)
        raise RuntimeError(
            "Timed out: source selection, portal startup or video frames did not complete; inspect desktop.png and portal.log"
        )


def handle_termination(signum, _frame):
    raise InterruptedError(f"Interrupted by {signal.Signals(signum).name}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--manual-picker",
        action="store_true",
        help="select the screen manually; wait up to 120 seconds",
    )
    args = parser.parse_args()
    artifacts = pathlib.Path(tempfile.mkdtemp(prefix="vm-firefox-screencast-"))
    print("ARTIFACTS", artifacts, flush=True)
    result = {"status": "fail", "events": [], "measurements": []}
    previous_handlers = {
        sig: signal.signal(sig, handle_termination)
        for sig in (signal.SIGTERM, signal.SIGHUP)
    }
    try:
        run_test(args.manual_picker, artifacts, result)
    except (
        OSError,
        subprocess.SubprocessError,
        RuntimeError,
        ValueError,
        KeyError,
        TypeError,
    ) as error:
        result["error"] = str(error)
        print(f"RESULT FAIL: {error}", flush=True)
        return 1
    except KeyboardInterrupt:
        result["error"] = "Interrupted"
        return 130
    else:
        result["status"] = "pass"
        print(
            "RESULT PASS: Firefox receives changing, non-black monitor frames",
            flush=True,
        )
        return 0
    finally:
        for sig, handler in previous_handlers.items():
            signal.signal(sig, handler)
        (artifacts / "result.json").write_text(json.dumps(result, indent=2) + "\n")


if __name__ == "__main__":
    raise SystemExit(main())
