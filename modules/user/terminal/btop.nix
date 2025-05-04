{...}: {
  programs.btop = {
    enable = true;
    package = null;
    settings = {
      # description https://github.com/aristocratos/btop#configurability
      color_theme = "/usr/share/btop/themes/ayu.theme";
      update_ms = 1300;
    };
  };
}
