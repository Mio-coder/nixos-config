# My nixos configuration
work in progres
## important info:

|                             | App                     |
| --------------------------- | ----------------------- |
| **Window Manager**          | Sway                    |
| **Terminal Emulator**       | Alacritty               |
| **Application Launcher**    | Tofi                    |
| **Notification Daemon**     | Mako                    |
| **network management tool** | NetworkManager          |
| **System resource monitor** | Btop                    |
| **Shell**                   | Bash + Starship         |
| **Text Editor**             | Neovim (Lunarvim)       |

## Structure
```
├── configuration.nix
├── flake.nix
├── hmConfig
│   ├── desktop     # programs for desktop
│   └── terminal    # prorgams for terminal / services
├── home.nix
├── hosts           # hosts
│   └── potato-nixos
│       ├── disk-config.nix              # disko config
│       ├── hardware-configuration.nix
│       ├── home.nix                     # host-specific home-manager config
│       └── wm.nix
├── nixosConfig
│   ├── desktop     # programs for desktop
│   └── terminal    # programs for terminal / services
├── pkgs            # programs outside nix
├── readme.md
├── secrets
├── shell.nix
├── switch.sh
└── todo.md
```
in some folders default.nix imports all nix files recursively


orignaly inspired by https://github.com/Rishabh5321/dotfiles
