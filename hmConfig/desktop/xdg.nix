{pkgs, ...}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "zathura.desktop";
      "image/vnd.djvu" = "zathura.desktop";
    };
  };
  xdg.desktopEntries.zathura = {
    name = "zathura";
    exec = "${pkgs.zathura}/bin/zathura";
  };
  xdg.portal = {
    enable = true;

    # Install both GTK and wlroots portals
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];

    # Make xdg-open go through portals (recommended on Wayland)
    xdgOpenUsePortal = true;

    # Explicit backend selection (important for >= 1.17)
    config = {
      common = {
        default = ["gtk" "wlr"];
      };

      # Optional: if you want wlroots preferred for screen sharing etc.
      wlroots = {
        default = ["wlr" "gtk"];
      };
    };
  };
}
