{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.sway = lib.mkEnableOption "Sway window manager";

  config = lib.mkIf config.my.sway {
    # Core Sway/Wayland enablement
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # makes GTK apps pick up themes
      extraSessionCommands = (
        if config.my.nvidia.external == false
        then "export WLR_DRM_DEVICES=\"$(realpath /dev/dri/by-path/pci-0000:00:02.0-card)\""
        else ""
      );
      # https://github.com/swaywm/sway/wiki/Running-programs-natively-under-wayland
      extraOptions = ["--unsupported-gpu"];
    };
    security.polkit.enable = true;
    security.pam.services.hyprlock = {};
    security.pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = 1;
      }
    ];
    programs.xwayland.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      wl-clipboard
      grim
      slurp
      swaybg
      # wlsunset
      swaylock
      swayidle
      void-sddm
    ];

    xdg.portal = {
      wlr.enable = true;
      xdgOpenUsePortal = true;
    };

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "voidsddm";
    };

    users.users.mio.extraGroups = ["video"];
    programs.light.enable = true;
  };
}
