{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixarr.nixosModules.default
  ];
  # my.windows = true;
  # Copied and adapted from
  # https://github.com/reo101/rix101/blob/35ba0d2fc7502d2db0eba975629c51d3bb5eff79/hosts/nixos/jeeves/modules/nixarr.nix
  nixarr = {
    enable = true;
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
    qbittorrent.enable = true;
    qbittorrent.vpn.enable = true;

    vpn.enable = true;
    vpn.wgConf = "/data/wg.conf";
  };

  services = {
    prowlarr.settings.auth.required = "DisabledForLocalAddresses";
    sonarr.settings.auth.required = "DisabledForLocalAddresses";
    radarr.settings.auth.required = "DisabledForLocalAddresses";
    lidarr.settings.auth.required = "DisabledForLocalAddresses";
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
}
