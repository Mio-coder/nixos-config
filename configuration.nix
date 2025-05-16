# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nixosModules/terminal/base.nix
    ./nixosModules/terminal/grub.nix
    ./nixosModules/terminal/fans.nix
    ./nixosModules/terminal/locale.nix
    ./nixosModules/terminal/docker.nix
    ./nixosModules/terminal/emulate_arch.nix
    ./nixosModules/terminal/keys.nix
    ./nixosModules/desktop/base.nix
    ./nixosModules/desktop/sound.nix
    # ./nixosModules/desktop/nvidia.nix
    ./nixosModules/desktop/gnome.nix
    # ./nixosModules/desktop/sway.nix
  ];

  networking.hostName = "omen-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hosts = {"10.14.87.141" = ["rpi.staszic"];};
  networking.firewall = {
    allowedUDPPorts = [2757 2758 2759]; # Supertuxkart ports
    allowedUDPPortRanges = [
      {
        from = 2757;
        to = 2759;
      }
    ];
  };
  boot.kernelModules = ["config_ip_multicast"];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mio = {
    isNormalUser = true;
    description = "mio";
    extraGroups = ["networkmanager" "wheel"];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  services.flatpak.enable = true;
  services.logind.lidSwitch = "ignore";

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = ["root" "mio"];
  };
}
