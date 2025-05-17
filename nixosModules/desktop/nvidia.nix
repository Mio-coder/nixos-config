{...}: {
  # nvidia drivers, copied from https://github.com/syshotdev/beginner-nixos-config/blob/main/modules/system/optimizations/gpu/nvidia/default.nix
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;

    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };

  # Some guy says this will fix "DRM kernel driver 'nvida-drm in use. NVK requires nouveau"
  boot.kernelParams = ["nvidia-drm.fbdev=1"];

  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  #   # https://discourse.nixos.org/t/getting-an-error-has-anything-regarding-opengl-in-nixpkgs/3641/3
  #   setLdLibraryPath = true;
  #   # Mesa is general opengl drivers (I think)
  #   extraPackages = [pkgs.mesa.drivers];
  # };
}
