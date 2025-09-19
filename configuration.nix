# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [
    ./wm.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nixosConfig/terminal/base.nix
    ./nixosConfig/terminal/nix.nix
    ./nixosConfig/terminal/grub.nix
    ./nixosConfig/terminal/fans.nix
    ./nixosConfig/terminal/locale.nix
    ./nixosConfig/terminal/docker.nix
    ./nixosConfig/terminal/emulate_arch.nix
    ./nixosConfig/terminal/networking.nix
    ./nixosConfig/terminal/ssh_server.nix
    ./nixosConfig/terminal/users.nix
    ./nixosConfig/terminal/vbox.nix
    ./nixosConfig/desktop/base.nix
    ./nixosConfig/desktop/sound.nix
    ./nixosConfig/desktop/sway.nix
    ./nixosConfig/desktop/kde.nix
    ./nixosConfig/desktop/gnome.nix
    ./nixosConfig/desktop/winapps.nix
    ./nixosConfig/desktop/nvidia.nix
    ./nixosConfig/desktop/vnc.nix
  ];
  boot.kernelModules = ["config_ip_multicast"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    jq
    cryptsetup
  ];

  # services.flatpak.enable = true;
  # services.tailscale.enable = true;
  services.logind.lidSwitch = "ignore";
  networking.firewall.enable = false;
  users = {
    defaultUserShell = pkgs.dash;
    users.root.shell = pkgs.dash;
  };
  environment.shells = with pkgs; [
    dash
  ];
  programs.nix-ld.enable = true;
}
