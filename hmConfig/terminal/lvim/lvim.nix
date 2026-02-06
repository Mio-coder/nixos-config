{pkgs, ...}: {
  home.packages = with pkgs; [
    (lunarvim.overrideAttrs (finalAttrs: previousAttrs: {
      runtimeDeps = previousAttrs.runtimeDeps ++ [python3 clang-tools];
    }))
    nixd
    emacs
  ];
  xdg.configFile."lvim/config.lua".source = ./lvim_config.lua;
  xdg.configFile."lvim/patches/nvim-treesitter-patches.patch".source = ./nvim-treesitter-patches.patch;
}
