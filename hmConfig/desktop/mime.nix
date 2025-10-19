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
}
