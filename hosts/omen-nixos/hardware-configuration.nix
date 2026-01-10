{
  config,
  lib,
  inputs,
  modulesPath,
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
    ])
    ++ [
      (inputs.nixos-hardware.outPath + "/common/gpu/intel/comet-lake")
    ];

  boot.loader.grub.useOSProber = true;
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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 64 * 1024;
    }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
