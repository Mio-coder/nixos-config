# https://discourse.nixos.org/t/nvidia-dgpu-prime-offload-mode-amd-igpu-wayland/63194/4
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.nvidia = {
    enable = lib.mkEnableOption "nvidia";
    external = lib.mkEnableOption "external monitor support";
  };
  config = lib.mkMerge [
    (lib.mkIf config.my.nvidia.enable {
      my.nvidia.external = lib.mkDefault true;

      boot.kernelPackages = pkgs.linuxPackages_6_18;
      # boot.kernelParams = [
      #   # optional but recommended with PreserveVideoMemoryAllocations:
      #   "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      # ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      services.xserver.videoDrivers = [
        "modesetting"
        "nvidia"
      ];

      hardware.nvidia = {
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        open = false;

        package = config.boot.kernelPackages.nvidiaPackages.latest;

        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
      nixpkgs.config.cudaSupport = true;
    })
    (
      lib.mkIf (config.my.nvidia.enable && config.my.nvidia.external) {
        hardware.nvidia.prime = {
          reverseSync.enable = true;
        };
      }
    )
  ];
}
