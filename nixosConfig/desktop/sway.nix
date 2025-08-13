{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.sway = lib.mkEnableOption "sway window manager (system)";

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

    # # Provide a simple TTY greeter that starts Sway
    # services.greetd = {
    #   enable = true;
    #   settings.default_session = {
    #     command = "sway";
    #     # Optional: log in with the first user at the greeter
    #     # user = "greeter"; # leave unset to show a login prompt
    #   };
    # };

    # Services sway uses
    users.users.mio.extraGroups = ["video"];
    programs.light.enable = true;
  };
}
