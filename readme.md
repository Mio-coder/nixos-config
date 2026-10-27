# My nixos configuration

## Important info:

|                             |                         |
| --------------------------- | ----------------------- |
| **Window Manager**          | Sway                    |
| **Terminal Emulator**       | Alacritty               |
| **Application Launcher**    | Tofi                    |
| **Notification Daemon**     | Mako                    |
| **Network management tool** | NetworkManager          |
| **System resource monitor** | Btop                    |
| **Shell**                   | Bash + Starship         |
| **Text Editor**             | Neovim (Lunarvim)       |

## Structure
```
├── configuration.nix     # system configuration base
├── docs
├── flake.lock
├── flake.nix             # main flake
├── hmConfig
│   ├── default.nix
│   ├── desktop           # user desktop programs
│   └── terminal          # everything else
├── home.nix              # base home configuration
├── hosts
│   ├── omen-nixos
│   │   ├── configuration.nix           # system conf
│   │   ├── disk-config.nix             # disk conf
│   │   ├── hardware-configuration.nix  # hardware conf
│   │   ├── home.nix                    # home configuration
│   │   └── wm.nix                      # shared config
│   ├── iso.nix           # half-baked live iso
│   └── potato-nixos
├── scripts
│   ├── install.sh        # common instalation commands
│   ├── switch.sh         # nixos-rebuild wrapper
│   └── update.sh         # commands to run when updating
├── nixosConfig
│   ├── desktop    # desktop configuration
│   └── terminal   # not desktop configuration
├── pkgs           # patches and custom packages
├── secrets        # secrets
└── readme.md
```

default.nix imports files in subdirectory

orignaly inspired by https://github.com/Rishabh5321/dotfiles

## VM screen-sharing test

With the NixOS VM running in Sway, run `./scripts/vm-screencast-test` on the host
to check actual monitor video capture through the portal in Chromium.
See [VM screen-sharing test](docs/vm-screencast-test.md) for setup, limitations,
manual source selection, and troubleshooting.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
