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
    };
    security.polkit.enable = true;
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
    ];

    # Portals for Wayland apps (screenshare, file dialogs)
    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };

    # Provide a simple TTY greeter that starts Sway
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "mio";
        };
        default_session = initial_session;
      };
    };
    # services.displayManager.ly = {
    #   enable = true;
    #   x11Support = false;
    #   settings = {
    #     clear_password = true;
    #     brightness_up_cmd = "light -A 10";
    #     brightness_down_cmd = "light -U 10";
    #     battery_id = "BAT0";
    #   };
    # };

    # Services sway uses
    users.users.mio.extraGroups = ["video"];
    programs.light.enable = true;
  };
}
