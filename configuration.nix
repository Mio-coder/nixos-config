# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  hostname,
  system,
  inputs,
  ...
}: {
  imports = [
    ./hosts/${hostname}/wm.nix
    ./hosts/${hostname}/hardware-configuration.nix
    ./hosts/${hostname}/configuration.nix
    ./nixosConfig/terminal
    ./nixosConfig/desktop
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.agenix.nixosModules.default
  ];
  boot.kernelModules = ["config_ip_multicast"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  services = {
    flatpak.enable = true;
    logind.settings.Login.HandleLidSwitch = "ignore";
    nixseparatedebuginfod2.enable = true;
    upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
    };
  };
  networking.firewall.enable = false;
  users = {
    defaultUserShell = pkgs.dash;
    users.root.shell = pkgs.dash;
  };
  environment.shells = with pkgs; [
    dash
  ];
  programs.nix-ld.enable = true;
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default

    libimobiledevice
    glibc.static
    ifuse
    usbmuxd
    firejail
    man-pages-posix
  ];

  services.usbmuxd.enable = true;
  programs.fuse.userAllowOther = true;
}
