_: {
  programs.btop = {
    enable = true;
    package = null; # provided by nixos
    settings = {
      # description https://github.com/aristocratos/btop#configurability
      color_theme = "ayu";
      update_ms = 1000;
    };
  };
}
