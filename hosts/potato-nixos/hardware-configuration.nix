{
  config,
  lib,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.disko.nixosModules.disko
    ./disk-config.nix
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "vmd" "usbhid" "uas" "sd_mod" "sdhci_pci"];
  boot.initrd.kernelModules = [];
  boot.extraModulePackages = [];
  networking.enableB43Firmware = true;

  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/cd874c04-5a38-4db2-ac63-84e7c2769e93";
  #   fsType = "ext4";
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/F508-0882";
  #   fsType = "vfat";
  #   options = ["fmask=0077" "dmask=0077"];
  # };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
