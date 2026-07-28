# Agent Log

Date: 2026-07-28

## User constraints

- Always commit progress.
- Use Nix to run commands where practical.
- Do not push git.
- Do runtime/debugging work inside the NixOS VM where possible.
- Do not modify Windows VM data or configuration without approval.
- User later approved configuring the Windows VM for the planned network migration.
- Do not record credentials, private keys, or VPN secrets here.

## Goal

Bring up the NixOS VM, make the nested Windows VPN VM reachable, and get the WireGuard tunnel working through that Windows VM.

Target migration:

- Dockurr container remains on Docker network address `172.30.0.2`.
- Nested Windows guest should move to static IP `10.10.0.2/24`.
- Windows gateway should be `10.10.0.1`.
- NixOS VM routes `10.10.0.0/24` via the Dockurr container at `172.30.0.2`.
- WireGuard should eventually use the Windows guest at `10.10.0.2:51820`.

## Completed work

- Fixed the VM Windows container service wiring.
- Added serial console helper scripts:
  - `scripts/vm-serial-start`
  - `scripts/vm-serial-stop`
  - `scripts/vm-serial-send`
  - `scripts/vm-serial-log`
- Added SSH access to the NixOS VM and helper script `scripts/vm-ssh`.
- Opened the NixOS VM firewall for SSH.
- Made the VM SSH helper tolerate ephemeral SSH host keys.
- Increased the outer NixOS VM memory and the nested Windows allocation to 16 GB.
- Rebuilt the VM repeatedly with `nixos-rebuild build-vm --flake .#vm`.
- Verified serial login and SSH access to the NixOS VM.
- Set up `/data` sharing/persistence from host into the VM.
- Mapped Windows storage as `/data/windows:/storage:rw`.
- Avoided offline modification of Windows data before approval.
- Preserved WireGuard startup waiting after the user asked why it had been removed.
- Added readiness handling so `wg.service` waits for `windows-vpn-ready.service`.
- Added route/NAT staging for the Windows migration:
  - `10.10.0.1/24` on the Dockurr guest-side interface.
  - MASQUERADE for `10.10.0.0/24` out through the container WAN interface.
  - NixOS route `10.10.0.0/24 via 172.30.0.2`.
  - Compatibility route `172.31.0.0/24 via 172.30.0.2`.
- Kept old compatibility DNAT from Dockurr address to the old nested Windows address while migration is incomplete.
- Fixed the container gateway setup so it does not fail on `sysctl -w net.ipv4.ip_forward=1` when forwarding is already enabled but the write is denied.

## Network diagnosis

The main issue is that the Dockurr container IP and the nested Windows guest IP are not the same endpoint.

- Outer NixOS VM Docker bridge: `172.30.0.0/24`.
- Dockurr container `windows_vpn`: `172.30.0.2`.
- Nested Windows guest, before migration: `172.31.0.2`.
- Dockurr guest-side gateway, before migration: `172.31.0.1`.
- Desired nested Windows guest: `10.10.0.2`.
- Desired Dockurr guest-side gateway: `10.10.0.1`.

Packets sent to `172.30.0.2` normally terminate at the Dockurr container. They do not automatically become packets to the nested Windows VM. That is why explicit routing, NAT, or DNAT is needed.

ICMP did not work because the Dockurr NAT/forwarding path was not transparently forwarding all protocols to the nested Windows guest, and the Windows firewall may also block echo requests.

## WireGuard state

Observed non-secret WireGuard config fields in `/data/wg.conf`:

```ini
Address = 10.66.66.2/24
AllowedIPs = 0.0.0.0/0
Endpoint = 172.30.0.2:51820
```

`wg.service` has been observed active, but that only proves systemd started the interface. It does not prove the tunnel has a recent handshake or that traffic works. Remaining validation must check `wg show`, routes, handshake age, and real traffic through the tunnel.

## Current runtime status

The outer NixOS VM previously kernel-panicked overnight with:

```text
Kernel panic - not syncing: Host injected async #PF in kernel mode
```

The VM was restarted with the helper scripts and came back up. After restart:

- `docker-windows_vpn.service` was active.
- `windows-vpn-gateway.service` was active.
- `windows-vpn-route.service` was active.
- `windows-vpn-ready.service` was active.
- `wg.service` was active.
- Direct RDP to old Windows address `172.31.0.2:3389` worked.
- SSH to old Windows address `172.31.0.2:22` initially appeared closed, then later became reachable.

Because SSH is now reachable, the next Windows configuration step should use SSH to `Docker@172.31.0.2` from inside the NixOS VM rather than headless RDP.

Temporary headless RDP state from before SSH became reachable:

- Xvfb display: `:99`
- `xfreerdp` was started against `172.31.0.2`.
- Temporary VM-side files were under `/tmp/windows-rdp/`.
- Host-side screenshot attempts were under `/tmp/windows-rdp*.png`.
- Screenshot capture was black, likely because the accelerated RDP surface did not render into the X screenshot.

## Sysctl issue

`sysctl -w net.ipv4.ip_forward=1` was denied inside the Dockurr container because container root with networking privileges still cannot always write that namespaced sysctl. In this setup, forwarding was already enabled, so the write was unnecessary and caused a false failure.

The gateway setup was changed to:

- read `/proc/sys/net/ipv4/ip_forward`,
- only attempt the sysctl write if the value is not already `1`,
- fail only if forwarding is still not enabled after that check.

Consequence: the service no longer fails just because an unnecessary sysctl write is denied, but it still catches the real failure case where forwarding is off.

## Remaining work

- SSH from inside the NixOS VM into Windows at `172.31.0.2`.
- Inspect Windows network state before changing anything:
  - `Get-NetAdapter`
  - `Get-NetIPConfiguration`
  - `Get-NetIPAddress -AddressFamily IPv4`
  - OpenSSH service state and startup type
- Configure only the correct Windows adapter:
  - IP `10.10.0.2`
  - prefix `/24`
  - gateway `10.10.0.1`
  - DNS based on the current working Windows resolver, unless the user approves a different resolver
- Expect the SSH session to drop during the IP switch.
- Reconnect to Windows at `10.10.0.2`.
- Verify SSH, RDP, ICMP, DNS, internet access, and Windows WireGuard endpoint reachability.
- Update `/data/wg.conf` endpoint from `172.30.0.2:51820` to `10.10.0.2:51820` after the new Windows IP is proven reachable.
- Restart WireGuard and verify handshake plus tunneled traffic.
- Remove old compatibility pieces only after the new path works:
  - DNAT from `172.30.0.2` to `172.31.0.2`
  - route for `172.31.0.0/24`
  - readiness fallback to the old address
- Rebuild and test the VM again.
- Commit each progress step.
- Do not push.

## Commits made during this work

```text
d032abc fix vm windows container service wiring
da13ffe add vm serial console helpers
3fe60a4 add ssh access to vm helper
2b95b89 fix vm serial helper and login user
16b09ec open vm firewall for ssh
85127a8 increase vm memory for nested windows
4d43b62 allocate 16g to nested windows vm
34a105f add vm ssh command helper
5c9b2a3 persist vm data on host and disable windows autostart
7029d58 allow vm ssh helper across ephemeral boots
b6e0a4e decouple windows vm from wireguard service
41f036d retain windows vpn startup dependency
b68692e wait for windows services before wireguard
f6e1baf route nested windows network through dockurr
c2c2935 dnat dockurr address to nested windows vm
a22a02d wait for dockurr before adding dnat rule
582b59e persist route to nested windows subnet
88b3b6d stage windows vpn network migration
cbc53ce allow dockurr gateway without sysctl write
e892ba1 verify forwarding before configuring vpn nat
```

## Worktree notes

At the time this log was written, these files had staged changes that were not part of this log update:

```text
hosts/vm/dummy_user.nix
hosts/vm/hardware-configuration.nix
hosts/vm/home.nix
hosts/vm/share_keys.nix
```

Those changes should be preserved and not included in the `agent_log.md` commit.
