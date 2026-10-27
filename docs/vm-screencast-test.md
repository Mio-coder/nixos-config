# VM screen-sharing test

`scripts/vm-screencast-test` checks actual monitor capture through Chromium's
`getDisplayMedia()` in the NixOS VM's Sway session. The guest-side implementation
is `scripts/vm-screencast-test.py`.

## Run from the host

```sh
./scripts/vm-serial-start
./scripts/vm-screencast-test
# When finished with the VM:
./scripts/vm-serial-stop
```

Skip the start command if the VM is already running. The test itself neither
starts nor stops the VM. It closes its own browser when finished.

Requirements:

- Nix on the host and SSH access through `scripts/vm-ssh`.
- An active Sway session in the VM (normally user `mio`, not the SSH user).
- Chromium, `swaymsg`, `slurp`, `grim`, `pgrep`, and `pw-dump` in the guest.
- Working user D-Bus, `xdg-desktop-portal`, `xdg-desktop-portal-wlr`, PipeWire,
  and WirePlumber in that graphical session.
- For automatic selection: one active output at `(0, 0)`, resolution `1280×800`,
  default scale/theme, and an empty focused workspace so Chromium fills it.
  No other `slurp` chooser may already be running. Do not move the pointer or
  interact with the desktop while the test is clicking.

The launcher builds Python with `websockets` using the repository's locked
`nixpkgs` input. It uses the host Nix store shared with the guest; it does not
install packages inside the VM or change the system configuration. The first
run may download/build dependencies. An editor using a different Python
environment may report `websockets.sync.client` as unresolved; the launcher
supplies this dependency through Nix rather than a global Python installation.
The browser loads only a temporary page
served on guest loopback, and its debugging endpoint also binds to loopback.

## What is checked

1. Open an isolated Chromium profile on Wayland and a local animated test page.
2. Call `getDisplayMedia({video: true, audio: false})` with a user gesture.
3. Select **Entire Screen** in Chromium, choose the monitor through the portal's
   `slurp` chooser, and confirm **Share**.
4. Require a monitor stream (`displaySurface: monitor`), not a browser-tab stream.
5. Sample the received video four times at roughly one-second intervals:
   - the received-frame counter must advance;
   - dimensions must be nonzero and the track must remain live;
   - sampled pixels must not all be black;
   - pixel sums must change between samples.

Success prints `STREAM`, `FRAME_MEASUREMENTS`, and:

```text
RESULT PASS: portal stream delivers changing, non-black video frames
```

The launcher returns exit code **0** on success and nonzero on failure. The
original VM test delivered `1280×800` video at approximately 30 frames/second.
The test does not require exactly that frame rate.

This is a local monitor-capture smoke test, not a network WebRTC call or a test
of a particular conferencing app. It does not test audio or individual-window
capture, or prove which backend was used on an arbitrary desktop. It is intended
for this VM's Sway/wlr portal setup. `PIPEWIRE_NODES` is diagnostic only, not a
separate pass condition.

## Manual source selection

Automatic clicks use fixed coordinates for the current Chromium dialog and
VM desktop layout. A Chromium UI update, different window size, scaling,
localization, or a slower chooser can invalidate them. A selection timeout
alone is therefore not proof of a portal failure.

For a different layout, use:

```sh
./scripts/vm-screencast-test --manual-picker
```

Within 120 seconds, choose **Entire Screen**, select the monitor in the portal,
and confirm **Share**. This requires access to the guest GUI; the serial helper
normally starts QEMU without a visible window. The automatic path waits about
40 seconds. The launcher additionally bounds the entire guest test service to
180 seconds.

## Accounts and environment

The launcher runs the test as the graphical user using `sudo` inside the VM and
a transient `systemd --user` service. This inherits Sway's display/socket
environment rather than the SSH session's environment; it explicitly sets the
Wayland session type to prevent Chromium from trying X11 capture.

Supported environment variables:

| Variable | Purpose |
| --- | --- |
| `VM_DESKTOP_USER` | Graphical session user; default `mio`. Its UID is discovered automatically. |
| `VM_SSH_PORT` | SSH forwarding port, as supported by `scripts/vm-ssh`. |
| `VM_SSH_USER` | SSH account, as supported by `scripts/vm-ssh`. It must be allowed to use sudo. |
| `VM_SSH_PASSWORD` | SSH password, as supported by `scripts/vm-ssh`; also used for sudo unless overridden. |
| `VM_SUDO_PASSWORD` | Separate sudo password, if needed. |

The default credentials are the existing test-VM defaults from the SSH helper.
Do not put real passwords in this document or commit them to the repository.

## Failure artifacts and cleanup

The guest prints an `ARTIFACTS /tmp/vm-screencast-test-...` directory owned by the
graphical user. It contains `chromium.log` and, if selection is still pending,
`browser-15.png`/`desktop-15.png` and `browser-40.png`/`desktop-40.png`. These are
captured after about 8 and 20 seconds, respectively. Screenshots can include
other windows on the VM desktop: inspect them locally and do not commit them.

The test closes Chromium, removes its temporary browser profile, and stops its
HTTP server. Logs/screenshots remain in the guest's `/tmp` for diagnosis until
removed or rebooted; the launcher removes its uploaded script. VM disk settings
and Windows configuration are not changed, and the NixOS VM is left running.

For portal diagnostics, use the graphical user's session bus (replace the UID
if necessary):

```sh
./scripts/vm-ssh -t 'sudo -u mio env XDG_RUNTIME_DIR=/run/user/1001 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1001/bus journalctl --user -b --no-pager -u xdg-desktop-portal -u xdg-desktop-portal-wlr'
```

If automation times out, inspect the screenshot first: Chromium may still be
waiting for a source selection or for the **Share** confirmation. If Chromium
reports X11/display errors, check that the Sway user manager has
`WAYLAND_DISPLAY` and `SWAYSOCK` imported. Do not judge the portal using the
SSH account's user services when the graphical session belongs to another user.
