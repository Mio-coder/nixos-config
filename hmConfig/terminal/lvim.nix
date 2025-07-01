{pkgs, ...}: {
  home.packages = with pkgs; [
    (lunarvim.overrideAttrs (finalAttrs: previousAttrs: {
      runtimeDeps = previousAttrs.runtimeDeps ++ [python3 clang-tools];
    }))
    nixd
  ];
  xdg.configFile."lvim/config.lua".source = ./lvim_config.lua;
}
