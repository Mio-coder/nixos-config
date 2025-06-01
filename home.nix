{
  pkgs,
  lpkgs,
  ...
}: {
  imports = [
    ./hmConfig/terminal/bash.nix
    ./hmConfig/terminal/btop.nix
    ./hmConfig/terminal/git.nix
    ./hmConfig/terminal/home_config.nix
    ./hmConfig/terminal/lofi.nix
    ./hmConfig/terminal/lvim.nix
    # ./hmConfig/terminal/minionki.nix
    ./hmConfig/terminal/pacman.nix
    ./hmConfig/terminal/shell.nix
    ./hmConfig/terminal/ssh.nix
    ./hmConfig/terminal/starship.nix
    ./hmConfig/terminal/tmux.nix
    ./hmConfig/terminal/f.nix
    ./hmConfig/desktop/alacritty.nix
    ./hmConfig/desktop/firefox.nix
    ./hmConfig/desktop/fonts.nix
    ./hmConfig/desktop/gnome.nix
  ];

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    uv
    act
    alejandra
    ungoogled-chromium
    man-db
    python312Packages.ipython
    localsend
    superTuxKart
    valgrind
    cling

    undollar # $ foo == foo
    libqalculate
    tldr # better man
    devenv
    speedtest-rs

    # my own
    (buildFHSEnv (appimageTools.defaultFhsEnvArgs
      // {
        name = "fhs";
        profile = ''export FHS=1'';
        runScript = "bash";
      }))
  ];
  home.sessionVariables = {
    CPLUS_INCLUDE_PATH = "${lpkgs.dbg-macro}/usr/include";
  };

  home.file = {
    ".gdbinit".text = "set debuginfod enabled on";
  };
}
