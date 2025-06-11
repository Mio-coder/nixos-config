_: {
  programs.btop = {
    enable = true;
    package = null;
    settings = {
      # description https://github.com/aristocratos/btop#configurability
      color_theme = "ayu";
      update_ms = 1300;
    };
  };
}
