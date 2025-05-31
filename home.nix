{
  pkgs,
  lpkgs,
  ...
}: {
  imports = [
    ./hmModules/terminal/bash.nix
    ./hmModules/terminal/btop.nix
    ./hmModules/terminal/git.nix
    ./hmModules/terminal/home_config.nix
    ./hmModules/terminal/lofi.nix
    ./hmModules/terminal/lvim.nix
    # ./hmModules/terminal/minionki.nix
    # ./hmModules/terminal/nix-index.nix
    ./hmModules/terminal/pacman.nix
    ./hmModules/terminal/shell.nix
    ./hmModules/terminal/ssh.nix
    ./hmModules/terminal/starship.nix
    ./hmModules/terminal/tmux.nix
    ./hmModules/terminal/f.nix
    ./hmModules/desktop/alacritty.nix
    ./hmModules/desktop/firefox.nix
    ./hmModules/desktop/fonts.nix
    ./hmModules/desktop/gnome.nix
    # ./hmModules/desktop/sway
  ];

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    # "$HOME/.junest/usr/bin_wrappers/"
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
