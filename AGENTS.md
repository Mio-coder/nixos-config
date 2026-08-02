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
- Start and stop the NixOS VM with the serial helpers, currently `./scripts/vm-serial-start` and `./scripts/vm-serial-stop`.
- Do not record credentials, private keys, VPN secrets, or other sensitive values in repo notes.
- Do not modify Windows VM data or configuration without approval. The user has approved configuring the nested Windows VM for the planned VPN network migration described below.

## Common Commands

- Format Nix files with `alejandra . -q`.
- Switch the current host with `./scripts/switch.sh`.
- Build the VM with `nixos-rebuild build-vm --flake .#vm`.
- Connect to the NixOS VM with `./scripts/vm-ssh`.
- VM serial helpers:
  - start: `./scripts/vm-serial-start`
  - stop: `./scripts/vm-serial-stop`
  - `./scripts/vm-serial-send`
  - `./scripts/vm-serial-log`
