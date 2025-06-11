{config, ...}: {
  # Graphics configuration for NVIDIA RTX 2070 (Turing architecture).
  # Enable OpenGL support and use the proprietary NVIDIA driver.
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # Use the stable NVIDIA driver package from the kernelPackages.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # Enable modesetting for Wayland compatibility.
    modesetting.enable = true;
    # Use NVIDIA’s open-source kernel module (requires Turing or newer):contentReference[oaicite:8]{index=8}.
    open = true;
    # Enable `nvidia-settings` utility (optional).
    nvidiaSettings = true;
  };
}
