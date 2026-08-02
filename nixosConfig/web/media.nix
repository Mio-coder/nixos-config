{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nixarr.nixosModules.default
  ];
  options.my.media.enable = lib.mkEnableOption "Media stack";
  config = lib.mkIf config.my.media.enable {
    # Copied and adapted from
    # https://github.com/reo101/rix101/blob/35ba0d2fc7502d2db0eba975629c51d3bb5eff79/hosts/nixos/jeeves/modules/nixarr.nix
    nixarr = {
      enable = config.my.media.enable;
      mediaDir = "/data/media";
      stateDir = "/data/.state/nixarr";

      jellyfin = {
        enable = true;
        openFirewall = true;
      };

      sonarr.enable = true;
      radarr.enable = true;
      prowlarr.enable = true;
      bazarr.enable = true;
      seerr.enable = true;
      qbittorrent = {
        enable = true;
        qui.enable = false;
        vpn.enable = true;

        privateTrackers.disableDhtPex = true;
        extraConfig = {
          "BitTorrent" = {
            "Session\\AddTrackersFromURLEnabled" = true;
            "Session\\AdditionalTrackersURL" = "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt";
            "Session\\AlternativeGlobalDLSpeedLimit" = 1000;
            "Session\\AlternativeGlobalUPSpeedLimit" = 1000;
            "Session\\BandwidthSchedulerEnabled" = true;
            "Session\\GlobalMaxRatio" = 0.01;
            "Session\\MaxActiveDownloads" = 10;
            "Session\\MaxActiveTorrents" = 15;
            "Session\\MaxActiveUploads" = 5;
          };

          "Preferences" = {
            "Scheduler\\end_time" = "@Variant(\\0\\0\\0\\xf\\xff\\xff\\xff\\xff)";
            "Scheduler\\start_time" = "@Variant(\\0\\0\\0\\xf\\x4\\xb8\\x7f\\0)";
            "WebUI\\APIKey" = "qbt_Xh5mMapjz7YT3IPeZw4meUAu3uQb";
          };
        };
      };

      vpn.enable = true;
      vpn.wgConf = "/data/wg.conf";
    };
    vpnNamespaces.wg.portMappings = [
      {
        from = 5252;
        to = 5252;
      }
    ];

    services = {
      prowlarr.settings.auth.required = "DisabledForLocalAddresses";
      sonarr.settings.auth.required = "DisabledForLocalAddresses";
      radarr.settings.auth.required = "DisabledForLocalAddresses";
    };
    systemd.services.wg = {
      wants = ["windows-vpn-ready.service"];
      after = ["windows-vpn-ready.service"];
    };
    # # NOTE: All *arr services and jellyfin share the `media` group.
    # # UMask 0002 ensures created files are group-readable/writable,
    # # so e.g. bazarr can read/write subs in dirs owned by jellyfin,
    # # and radarr can manage metadata alongside jellyfin.
    # # Jellyfin upstream defaults to 0077 — mkForce is needed to override.
    # systemd.services =
    #   lib.genAttrs
    #   [
    #     "jellyfin"
    #     "transmission"
    #     "sonarr"
    #     "radarr"
    #     "prowlarr"
    #     "bazarr"
    #     "readarr"
    #     "lidarr"
    #   ]
    #   (_: {
    #     serviceConfig.UMask = lib.mkForce "0002";
    #   });
  };
}
