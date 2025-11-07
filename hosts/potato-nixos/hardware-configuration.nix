{
  modulesPath,
  inputs,
  ...
}: {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.disko.nixosModules.disko
      ./disk-config.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-pc-laptop
      common-pc-ssd
    ]);

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "vmd"
    "usbhid"
    "uas"
    "sd_mod"
    "sdhci_pci"
  ];
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
}
