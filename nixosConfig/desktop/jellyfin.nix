{...}: {
  services.jellyfin.enable = true;
  services.jellyfin.hardwareAcceleration.enable = true;
  services.jellyfin.hardwareAcceleration.type = "nvenc";
  services.jellyfin.transcoding.enableHardwareEncoding = true;
  services.jellyfin.hardwareAcceleration.device = "/dev/dri/by-path/pci-0000:01:00.0-card";
  services.jellyfin.openFirewall = true;
}
