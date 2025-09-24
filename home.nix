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
    ./hmConfig/desktop/sway.nix
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
  my.lofi.download = true;

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
  ];
  home.sessionVariables = {
    CPLUS_INCLUDE_PATH = "${lpkgs.dbg-macro}/usr/include";
  };

  home.file = {
    ".gdbinit".text = "set debuginfod enabled on";
  };
}
