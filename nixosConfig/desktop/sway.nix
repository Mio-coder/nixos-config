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

    # Useful Wayland tools
    environment.systemPackages = with pkgs; [
      wl-clipboard
      grim
      slurp
      swaybg
      wlsunset
      swaylock
      swayidle
      (pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        accent = "mauve";
      })
    ];

    # Portals for Wayland apps (screenshare, file dialogs)
    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };

    # Provide a simple TTY greeter that starts Sway
    # docs says that greetd does not work with services.xserver.displayManager.setupCommands
    # https://nixos.wiki/wiki/Nvidia#Optimus_Option_C:_Reverse_Sync_Mode_.28Experimental.29
    # services.greetd = {
    #   enable = true;
    #   settings = rec {
    #     initial_session = {
    #       command = "${sway-igpu}/bin/sway-igpu";
    #       user = "mio";
    #     };
    #     default_session = initial_session;
    #   };
    # };
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha-mauve";
    };

    # Services sway uses
    users.users.mio.extraGroups = ["video"];
    programs.light.enable = true;
  };
}
