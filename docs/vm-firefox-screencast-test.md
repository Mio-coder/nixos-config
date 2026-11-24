# Firefox screen-sharing test in the NixOS VM

Run from the host, with the VM already running:

```sh
./scripts/vm-firefox-screencast-test
```

The launcher **does not start or stop the VM**. To manage it explicitly, use
`./scripts/vm-serial-start` and `./scripts/vm-serial-stop`. In particular, running
the test against a stopped VM fails at SSH; it does not boot the VM automatically.

The guest implementation is `scripts/vm-firefox-screencast-test.py`. It uses
Python's standard library, without Selenium, geckodriver, Marionette, fake capture
devices, or pre-granted media permissions. The launcher gets Python from this
repository's locked `nixpkgs` and uses the Nix store shared with the VM.

## Requirements and automatic selection

- Host: Nix and SSH access through the existing `scripts/vm-ssh` helper. The
  first run may download/build Python; no guest package installation is needed.
- Guest: an active Sway session (normally user `mio`), Firefox, `swaymsg`,
  `slurp`, `pgrep`, `grim`, `journalctl`, the desktop portal, its wlr backend,
  and PipeWire/WirePlumber.
- Automatic mode expects one active, powered-on **1280×800** output at `(0, 0)`,
  scale 1, and an empty focused workspace. No other `slurp` chooser may be open.
- The temporary profile uses Firefox's classic UI (`browser.nova.enabled=false`,
  matching the configured main profile). The automatic **Allow** click assumes
  the English UI/layout tested with Firefox 160.0.1. The operating-system picker
  must already be the selected source; the script does not change media permissions.
- Automatic monitor selection supports the portal's `slurp` chooser. For other
  selectors, different scaling, localization, or Firefox UI changes, use manual
  mode. Do not interact with the VM desktop while automatic clicks run.

Manual mode gives 120 seconds instead of the automatic mode's 60:

```sh
./scripts/vm-firefox-screencast-test --manual-picker
```

Click the large test-page button, choose **Use operating system settings** in
Firefox, press **Allow**, and select a monitor in the portal. Manual mode needs
access to the guest GUI; the serial start helper normally runs QEMU without a
visible window. The launcher bounds the whole guest test service to 180 seconds.

## What counts as success

The page is served on guest loopback. It calls
`navigator.mediaDevices.getDisplayMedia({video:true,audio:false})` from a real
button click and plays the received stream in a muted video element. The test
requires:

1. `displaySurface: monitor` — sharing only a Firefox tab/window is not a pass.
2. Four samples taken about one second apart, with nonzero video dimensions
   and a live track.
3. Increasing received-frame counters and video timestamps.
4. Nonblack sampled pixels and a different pixel hash for every consecutive
   sample while the page animates, including rejection of a partial freeze.

Success returns exit code **0** and prints the completion marker below. The
launcher requires this exact marker as well as a successful service exit; a
service that ends without finishing the capture test is not a pass.

```text
RESULT PASS: Firefox receives changing, non-black monitor frames
```

A browser refusal (including `NotAllowedError`), premature exit, missing frames,
black/frozen video, incorrect source, or timeout returns **1** from the guest
checker and prints `RESULT FAIL: ...`. Launcher/SSH/sudo failures also return
nonzero but may not have a browser-test result. Invalid command-line options
return **2**. Ctrl+C in the guest checker returns **130**. SIGTERM/SIGHUP are
handled as failures with cleanup rather than systemd's clean signal exits.

This is a local capture smoke test, not a remote WebRTC call. It does not test
audio, individual-window capture, conferencing apps, or the main profile's
extensions. A successful stream alone does not identify the portal backend;
the script is intended for this VM's Sway/wlr setup.

## Artifacts and troubleshooting

The guest prints `ARTIFACTS /tmp/vm-firefox-screencast-...`. That directory holds:

- `result.json`: pass/fail status, error, stream settings, browser reports,
  and frame samples;
- `firefox.log`: browser stdout/stderr;
- on failure after browser startup, `desktop.png`, `portal.log`, and
  `diagnostics.log`. The screenshot is taken **before** closing Firefox so a
  pending permission/chooser dialog remains visible. Diagnostic commands have
  their own timeouts; an unavailable screenshot tool does not turn failure into
  success.

The browser, its content processes, temporary profile, uploaded script and local
HTTP server are cleaned up. The launcher also attempts to stop its uniquely
named guest service when interrupted; if SSH is lost, the 180-second service
runtime limit remains the fallback. Logs/screenshots remain in guest `/tmp` until removed
or rebooted. Screenshots can contain other VM windows; do not commit them.
The script does not change portal settings, the regular Firefox profile, VM disk
settings, or Windows configuration.

A previous interactive check of this VM failed with `NotAllowedError`: wlr's
source selector could not find menu programs in its service `PATH`, even though
`wmenu` was available in the ordinary system environment. Its log contained
`wmenu: command not found` and `wlroots: no output found`. This test deliberately
reports that problem rather than adding a workaround or treating active
services as proof that screen sharing works. A timeout can also mean automatic
click coordinates no longer match the UI; inspect `desktop.png` first.

The launcher supports the same account variables as the Chromium test:
`VM_DESKTOP_USER` (default `mio`), `VM_SSH_PORT`, `VM_SSH_USER`,
`VM_SSH_PASSWORD`, and optional `VM_SUDO_PASSWORD`. The desktop UID is discovered
automatically, and the test runs through its user systemd manager to inherit
Sway's display environment. Never record real credentials in repository notes.

## Offline tests

These do not start a VM or browser:

```sh
nix shell --inputs-from . nixpkgs#python3 --command \
  python3 scripts/test-vm-firefox-screencast-test.py
```

They check monitor-source validation, live/changing-frame criteria, failure exit
status and JSON output, and the local HTTP report receiver. Launcher tests use
fake Nix/SSH helpers to verify completion markers, service errors, and cleanup
without contacting a VM. They do not replace an end-to-end capture test in the VM.
