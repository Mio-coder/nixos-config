_: {
  boot.initrd.availableKernelModules = ["vmd" "nvme" "ahci" "libahci" "dm_mod" "md_mod"];
  boot.kernelModules = ["vmd" "nvme" "ahci" "libahci" "dm_mod" "md_mod"];
}
