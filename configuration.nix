# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nixosModules/terminal/base.nix
    ./nixosModules/terminal/nix.nix
    ./nixosModules/terminal/grub.nix
    ./nixosModules/terminal/fans.nix
    ./nixosModules/terminal/locale.nix
    ./nixosModules/terminal/docker.nix
    ./nixosModules/terminal/emulate_arch.nix
    ./nixosModules/terminal/networking.nix
    ./nixosModules/desktop/base.nix
    ./nixosModules/desktop/sound.nix
    ./nixosModules/desktop/gnome.nix
    # ./nixosModules/desktop/winapps.nix

    # ./nixosModules/desktop/winapps_mod.nix
  ];
  boot.kernelModules = ["config_ip_multicast"];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mio = {
    isNormalUser = true;
    description = "mio";
    extraGroups = ["networkmanager" "wheel" "vboxusers"];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  services.flatpak.enable = true;
  services.logind.lidSwitch = "ignore";
  virtualisation.virtualbox.host.enable = true; # also move vboxusers group
  # virtualisation.windows-vm = {
  #   enable = true;
  #   ramSize = "16G";
  #   cpuCores = 8;
  #   isoPath = "/home/mio/torrents/tiny-11-NTDEV/tiny11_b1.iso";
  #   openFirewall = true;
  # };
}
