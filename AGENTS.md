# Agent Instructions

## Repository

- This is a personal NixOS flake for multiple hosts.
- Main entry points:
  - `flake.nix` defines `potato-nixos`, `omen-nixos`, and `vm` NixOS configurations.
  - `configuration.nix` is the shared system base.
  - `home.nix` is the shared Home Manager base.
  - `hosts/<name>/` contains host-specific system, hardware, disk, home, and window-manager files.
  - `nixosConfig/` contains reusable NixOS modules.
  - `hmConfig/` contains reusable Home Manager modules.
  - `pkgs/` contains custom packages and patches.
  - `scripts/` contains workflow helpers.
- Directory-level convention: `default.nix` imports files in its subdirectory.

## Working Rules

- Always commit progress when doing multi-step repo work, but do not push.
- Use Nix to run commands where practical.
- Prefer the existing scripts and local module patterns over introducing new workflow machinery.
- Do not record credentials, private keys, VPN secrets, or other sensitive values in repo notes.
- Do not modify Windows VM data or configuration without approval. The user has approved configuring the nested Windows VM for the planned VPN network migration described below.

## Common Commands

- Format Nix files with `alejandra . -q`.
- Switch the current host with `./scripts/switch.sh`.
- Build the VM with `nixos-rebuild build-vm --flake .#vm`.
- Connect to the NixOS VM with `./scripts/vm-ssh`.
- VM serial helpers:
  - `./scripts/vm-serial-start`
  - `./scripts/vm-serial-stop`
  - `./scripts/vm-serial-send`
  - `./scripts/vm-serial-log`

## VM/VPN Handoff

Current operational goal: bring up the NixOS VM, make the nested Windows VPN VM reachable, and get WireGuard working through that Windows VM.

Planned network state:

- Dockurr container stays at Docker network address `172.30.0.2`.
- Nested Windows guest should move from `172.31.0.2` to static IP `10.10.0.2/24`.
- Windows gateway should be `10.10.0.1`.
- NixOS VM routes `10.10.0.0/24` via Dockurr container `172.30.0.2`.
- WireGuard should eventually use endpoint `10.10.0.2:51820`.

Important network distinction:

- `172.30.0.2` is the Dockurr container endpoint.
- `172.31.0.2` is the old nested Windows guest endpoint.
- Packets sent to `172.30.0.2` do not automatically reach the nested Windows guest; explicit route, NAT, or DNAT handling is required.

Current staged behavior from prior work:

- VM SSH is enabled, with helper tolerant of ephemeral host keys.
- `/data` is shared/persisted from host into the VM.
- Windows storage is mapped as `/data/windows:/storage:rw`.
- `wg.service` waits for `windows-vpn-ready.service`.
- Route/NAT staging has been added for the Windows migration:
  - `10.10.0.1/24` on the Dockurr guest-side interface.
  - MASQUERADE for `10.10.0.0/24` out through the container WAN interface.
  - NixOS route `10.10.0.0/24 via 172.30.0.2`.
  - Compatibility route `172.31.0.0/24 via 172.30.0.2`.
  - Compatibility DNAT from the Dockurr address to old nested Windows address remains while migration is incomplete.
- The Dockurr gateway setup should not fail solely because `sysctl -w net.ipv4.ip_forward=1` is denied when forwarding is already enabled.

WireGuard observations:

- Non-secret fields previously observed in `/data/wg.conf`:
  - `Address = 10.66.66.2/24`
  - `AllowedIPs = 0.0.0.0/0`
  - `Endpoint = 172.30.0.2:51820`
- `wg.service` being active only proves systemd started the interface. Validate with `wg show`, handshake age, routes, and real tunneled traffic.

Next VM/VPN steps:

- SSH from inside the NixOS VM into Windows at `172.31.0.2` as `Docker@172.31.0.2`.
- Inspect Windows state before changing anything:
  - `Get-NetAdapter`
  - `Get-NetIPConfiguration`
  - `Get-NetIPAddress -AddressFamily IPv4`
  - OpenSSH service state and startup type
- Configure only the correct Windows adapter:
  - IP `10.10.0.2`
  - prefix `/24`
  - gateway `10.10.0.1`
  - DNS based on the current working Windows resolver unless the user approves a different resolver
- Expect the SSH session to drop during the IP switch.
- Reconnect to Windows at `10.10.0.2`.
- Verify SSH, RDP, ICMP, DNS, internet access, and Windows WireGuard endpoint reachability.
- Update `/data/wg.conf` endpoint from `172.30.0.2:51820` to `10.10.0.2:51820` only after the new Windows IP is proven reachable.
- Restart WireGuard and verify handshake plus tunneled traffic.
- Remove old compatibility pieces only after the new path works:
  - DNAT from `172.30.0.2` to `172.31.0.2`
  - route for `172.31.0.0/24`
  - readiness fallback to the old address
- Rebuild and test the VM again.

## Known Runtime Note

- The outer NixOS VM previously kernel-panicked overnight with `Kernel panic - not syncing: Host injected async #PF in kernel mode`.
- After restart, these services were observed active: `docker-windows_vpn.service`, `windows-vpn-gateway.service`, `windows-vpn-route.service`, `windows-vpn-ready.service`, and `wg.service`.
- Direct RDP to old Windows address `172.31.0.2:3389` worked.
- SSH to old Windows address `172.31.0.2:22` later became reachable, so prefer SSH from inside the NixOS VM over headless RDP.
