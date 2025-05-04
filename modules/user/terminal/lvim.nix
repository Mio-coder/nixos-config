{pkgs, ...}: {
  home.packages = with pkgs; [
    lunarvim
    nixd
  ];
  xdg.configFile."lvim/config.lua".source = ../../../dotfiles/lvim/config.lua;
}
