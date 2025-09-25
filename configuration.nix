# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hosts/${hostname}/wm.nix
    ./hosts/${hostname}/hardware-configuration.nix
    ./nixosConfig/terminal
    ./nixosConfig/desktop
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
  services.tailscale.enable = true;
  services.logind.settings.Login.HandleLidSwitch = "ignore";
  networking.firewall.enable = false;
  users = {
    defaultUserShell = pkgs.dash;
    users.root.shell = pkgs.dash;
  };
  environment.shells = with pkgs; [
    dash
  ];
  programs.nix-ld.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
