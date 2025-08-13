{
  config,
  lib,
  ...
}: {
  options.my.nvidia = lib.mkEnableOption "NVIDIA drivers and settings";

  config = lib.mkIf config.my.nvidia {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      open = false;
      # datacenter.enable = true;
    };
    # hardware.nvidia-container-toolkit.enable = true;
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.nvidia.acceptLicense = true;
  };
}
