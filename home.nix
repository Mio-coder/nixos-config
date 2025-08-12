{
  pkgs,
  lpkgs,
  ...
}: {
  imports = [
    ./wm.nix
    ./hmConfig/terminal
    ./hmConfig/desktop/alacritty.nix
    ./hmConfig/desktop/firefox.nix
    ./hmConfig/desktop/fonts.nix
    ./hmConfig/desktop/i3.nix
    ./hmConfig/desktop/gnome.nix
    ./hmConfig/desktop/dconf.nix
    ./hmConfig/desktop/kde.nix
    ./hmConfig/desktop/plasma.nix
    ./hmConfig/desktop/vscode.nix
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
    valgrind
    rsync
    gnumake
    undollar # $ foo == foo
    libqalculate
    tldr # better man
    rustdesk
    cling
    speedtest-rs
    asciiquarium-transparent
    llvmPackages_21.clang-tools
    lldb_21
    pv
    just

    devenv
    sd
    diskus

    # my own
    (buildFHSEnv (appimageTools.defaultFhsEnvArgs
      // {
        name = "fhs";
        profile = ''export FHS=1'';
        runScript = writeShellScript "fhs-exec.sh" ''
          if [ $# -eq 0 ]; then
              exec bash
          else
              exec "$@"
          fi
        '';
      }))
  ];
  home.sessionVariables = {
    CPLUS_INCLUDE_PATH = "${lpkgs.dbg-macro}/usr/include";
  };

  home.file = {
    ".gdbinit".text = "set debuginfod enabled on";
  };
}
