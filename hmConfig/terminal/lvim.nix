{pkgs, ...}: {
  home.packages = with pkgs; [
    lunarvim
    nixd
  ];
  xdg.configFile."lvim/config.lua".source = ../../dotfiles/lvim/config.lua;
  home.file.".local/share/lvim/mason/bin/clangd".source = "${pkgs.llvmPackages_19.clang-tools}/bin/clangd";
}
