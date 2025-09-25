{pkgs, ...}: {
  # Use the modesetting driver with Mesa (recommended for Intel)
  services.xserver.videoDrivers = ["modesetting"];

  # Enable Mesa's VA-API/VDPAU acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # newer Intel driver (for Gen8+ but works better sometimes)
      vaapiIntel # legacy driver, needed for Gen7/HD4000
      libvdpau-va-gl # VDPAU → VA-API bridge
    ];
  };
}
