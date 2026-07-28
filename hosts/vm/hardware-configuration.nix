{
  config,
  lib,
  inputs,
  modulesPath,
  ...
}: {
  imports = [];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "vmd"
    "usbhid"
    "uas"
    "sd_mod"
    "sdhci_pci"
  ];
  virtualisation.diskImage = null;
  boot.initrd.kernelModules = [];
  boot.extraModulePackages = [];
  nixpkgs.hostPlatform = "x86_64-linux";
}
