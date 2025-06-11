{
  config,
  pkgs,
  lib,
  ...
}: {
  # {
  #   pkgs,
  #   lib,
  #   config,
  #   ...
  # }: {
  options.my.kde = lib.mkEnableOption "kde";
  config = lib.mkIf config.my.kde {
    # Enable the X11 windowing system (required by SDDM and as a fallback).
    # (Plasma6 can also run on Wayland by default.)
    services.xserver.enable = true;

    # Enable SDDM as the graphical login manager.
    # This provides a login screen for choosing sessions.
    services.displayManager.sddm.enable = true;

    # Default to the X11 Plasma 6 session on login.
    # Plasma6 defaults to Wayland; "plasmax11" forces an X11 session by default:contentReference[oaicite:5]{index=5}.
    services.displayManager.defaultSession = "plasmax11";

    # Enable KDE Plasma 6 desktop environment.
    services.desktopManager.plasma6.enable = true;

    # Add the i3 tiling window manager (X11).
    # i3 integrates stably with Plasma on X11 (Sway is not compatible as a Plasma WM):contentReference[oaicite:6]{index=6}:contentReference[oaicite:7]{index=7}.
    services.xserver.windowManager.i3 = {
      enable = true;
      # Optional i3 tools and status bar:
      extraPackages = with pkgs; [
        dmenu # menu launcher
        i3status # status bar (or you can use i3blocks/etc.)
      ];
    };
  };
}
