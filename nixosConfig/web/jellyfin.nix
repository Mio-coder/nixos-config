{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.my.media.enable {
    services.jellyfin = {
      # enable = true;
      # openFirewall = true;

      # Make the NixOS settings overwrite Jellyfin's existing encoding.xml.
      # Changes made in Jellyfin's transcoding dashboard will be overwritten
      # when the service restarts.
      forceEncodingConfig = true;

      hardwareAcceleration = {
        enable = true;
        type = "nvenc";

        # Required by the current NixOS module. NVENC itself selects the
        # NVIDIA GPU through CUDA/NVENC rather than this DRI path.
        device = "/dev/dri/by-path/pci-0000:01:00.0-card";
      };

      transcoding = {
        enableHardwareEncoding = true;

        hardwareDecodingCodecs = {
          h264 = true;
          hevc = true;
          hevc10bit = true;
          hevcRExt10bit = true;
          hevcRExt12bit = true;

          mpeg2 = true;
          vc1 = true;
          vp8 = true;
          vp9 = true;
          av1 = true;
        };

        # H.264 hardware encoding is always enabled by the module.
        hardwareEncodingCodecs = {
          hevc = true;
          av1 = true;
        };

        enableToneMapping = true;
        throttleTranscoding = false;
        threadCount = null;
      };
    };

    # Permit Jellyfin to use the NVIDIA and DRM devices.
    users.users.jellyfin.extraGroups = [
      "video"
      "render"
    ];

    # The Jellyfin module otherwise allows only the single device specified
    # above. NVENC generally needs several /dev/nvidia* device nodes.
    systemd.services.jellyfin.serviceConfig = {
      PrivateDevices = lib.mkForce false;
      DevicePolicy = lib.mkForce "auto";
      DeviceAllow = lib.mkForce [];
      SupplementaryGroups = [
        "video"
        "render"
      ];
    };
  };
}
