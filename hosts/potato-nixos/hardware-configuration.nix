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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
