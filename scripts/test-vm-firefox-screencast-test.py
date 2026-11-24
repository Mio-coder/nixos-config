#!/usr/bin/env python3
"""Offline checks for the Firefox capture test; no VM or browser is started."""

import contextlib
import http.client
import importlib.util
import io
import json
import os
import pathlib
import shutil
import signal
import subprocess
import sys
import tempfile
import threading
import unittest
from unittest import mock

spec = importlib.util.spec_from_file_location(
    "firefox_test", pathlib.Path(__file__).with_name("vm-firefox-screencast-test.py")
)
if spec is None or spec.loader is None:
    raise RuntimeError("Could not load Firefox capture checker")
firefox_test = importlib.util.module_from_spec(spec)
with mock.patch.object(sys, "dont_write_bytecode", True):
    spec.loader.exec_module(firefox_test)


def frames():
    return [
        {
            "width": 1280,
            "height": 800,
            "frames": i * 30,
            "currentTime": float(i),
            "nonblackPixels": 2560,
            "pixelSum": 10000 + i,
            "pixelHash": i,
            "readyState": "live",
        }
        for i in range(1, 5)
    ]


class CaptureValidationTests(unittest.TestCase):
    def test_monitor_is_accepted(self):
        firefox_test.validate_stream({"displaySurface": "monitor"})

    def test_tabs_windows_and_missing_source_are_rejected(self):
        for settings in (
            {"displaySurface": "browser"},
            {"displaySurface": "window"},
            {},
        ):
            with self.subTest(settings=settings), self.assertRaises(RuntimeError):
                firefox_test.validate_stream(settings)

    def test_changing_live_frames_are_accepted(self):
        firefox_test.validate_frames(frames())

    def test_insufficient_samples_are_rejected(self):
        with self.assertRaises(RuntimeError):
            firefox_test.validate_frames(frames()[:3])

    def test_bad_frames_are_rejected(self):
        for key, value in (
            ("width", 0),
            ("height", 0),
            ("nonblackPixels", 0),
            ("readyState", "ended"),
        ):
            samples = frames()
            samples[2][key] = value
            with self.subTest(key=key), self.assertRaises(RuntimeError):
                firefox_test.validate_frames(samples)

    def test_frozen_counter_time_and_image_are_rejected(self):
        for key in ("frames", "currentTime", "pixelHash"):
            samples = frames()
            for sample in samples:
                sample[key] = 1
            with self.subTest(key=key), self.assertRaises(RuntimeError):
                firefox_test.validate_frames(samples)

    def test_partial_image_freeze_is_rejected(self):
        samples = frames()
        samples[2]["pixelHash"] = samples[3]["pixelHash"] = samples[1]["pixelHash"]
        with self.assertRaises(RuntimeError):
            firefox_test.validate_frames(samples)

    def test_termination_is_not_a_clean_exit(self):
        with self.assertRaisesRegex(InterruptedError, "SIGTERM"):
            firefox_test.handle_termination(signal.SIGTERM, None)

    def test_cli_preserves_portal_error_and_returns_failure(self):
        with tempfile.TemporaryDirectory() as directory:
            with (
                mock.patch("sys.argv", ["vm-firefox-screencast-test.py"]),
                mock.patch.object(
                    firefox_test.tempfile, "mkdtemp", return_value=directory
                ),
                mock.patch.object(
                    firefox_test,
                    "run_test",
                    side_effect=RuntimeError("getDisplayMedia: NotAllowedError"),
                ),
                contextlib.redirect_stdout(io.StringIO()) as output,
            ):
                self.assertEqual(firefox_test.main(), 1)
            result = json.loads((pathlib.Path(directory) / "result.json").read_text())
            self.assertEqual(result["status"], "fail")
            self.assertIn("NotAllowedError", result["error"])
            self.assertIn("RESULT FAIL", output.getvalue())


class ReportServerTests(unittest.TestCase):
    def setUp(self):
        self.server = firefox_test.ReportServer()
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()
        self.client = http.client.HTTPConnection(
            "127.0.0.1", self.server.server_port, timeout=3
        )

    def tearDown(self):
        self.client.close()
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(timeout=3)

    def test_page_contains_real_capture_without_fake_streams(self):
        self.client.request("GET", "/")
        response = self.client.getresponse()
        self.assertEqual(response.status, 200)
        self.assertIn(
            b"navigator.mediaDevices.getDisplayMedia({video:true,audio:false})",
            response.read(),
        )

    def test_report_reaches_queue(self):
        event = {"status": "error", "name": "NotAllowedError"}
        self.client.request("POST", "/report", body=json.dumps(event))
        response = self.client.getresponse()
        self.assertEqual(response.status, 204)
        response.read()
        self.assertEqual(self.server.reports.get(timeout=1), event)

    def test_invalid_reports_are_rejected(self):
        for payload in ("[]", "{", "{}"):
            with self.subTest(payload=payload):
                self.client.request("POST", "/report", body=payload)
                response = self.client.getresponse()
                self.assertEqual(response.status, 400)
                response.read()
        self.assertTrue(self.server.reports.empty())

    def test_unexpected_path_is_rejected(self):
        self.client.request("GET", "/favicon.ico")
        response = self.client.getresponse()
        self.assertEqual(response.status, 404)
        response.read()


class LauncherTests(unittest.TestCase):
    def run_launcher(self, marker, guest_exit=0):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            scripts = root / "scripts"
            scripts.mkdir()
            binary = root / "bin"
            binary.mkdir()
            launcher = scripts / "vm-firefox-screencast-test"
            shutil.copy2(pathlib.Path(__file__).with_name(launcher.name), launcher)
            (scripts / "vm-firefox-screencast-test.py").write_text(
                "# Never executed by these tests.\n"
            )
            nix = binary / "nix"
            nix.write_text(
                '#!/usr/bin/env bash\nprintf "%s\\n" /nix/store/offline-test-python\n'
            )
            ssh = scripts / "vm-ssh"
            ssh.write_text("""#!/usr/bin/env bash
case "$*" in
  'mktemp -d /tmp/vm-firefox-test.XXXXXX') echo /tmp/vm-firefox-test.OFFLINE ;;
  *'chmod 755'*) cat >/dev/null ;;
  *'systemd-run'*) cat >/dev/null; printf '%s\\n' "$FAKE_RESULT"; exit "$FAKE_EXIT" ;;
  *'systemctl --user stop'*) cat >/dev/null; echo stopped >> "$FAKE_TRACE" ;;
  *) echo 'Unexpected SSH command' >&2; exit 99 ;;
esac
""")
            for helper in (nix, ssh):
                helper.chmod(0o755)
            trace = root / "trace"
            completed = subprocess.run(
                ["bash", str(launcher)],
                capture_output=True,
                text=True,
                timeout=10,
                check=False,
                env={
                    **os.environ,
                    "PATH": str(binary) + os.pathsep + os.environ["PATH"],
                    "FAKE_RESULT": marker,
                    "FAKE_EXIT": str(guest_exit),
                    "FAKE_TRACE": str(trace),
                },
            )
            self.assertEqual(trace.read_text().strip(), "stopped")
            return completed

    def test_completed_capture_passes(self):
        result = self.run_launcher(
            "RESULT PASS: Firefox receives changing, non-black monitor frames"
        )
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_clean_exit_without_completed_test_is_not_pass(self):
        result = self.run_launcher("")
        self.assertEqual(result.returncode, 1)
        self.assertIn("without a completed", result.stderr)

    def test_portal_failure_stays_failure(self):
        result = self.run_launcher("RESULT FAIL: NotAllowedError", guest_exit=1)
        self.assertEqual(result.returncode, 1)

    def test_completion_marker_does_not_mask_service_error(self):
        result = self.run_launcher(
            "RESULT PASS: Firefox receives changing, non-black monitor frames",
            guest_exit=1,
        )
        self.assertEqual(result.returncode, 1)


if __name__ == "__main__":
    unittest.main()
