{
  pkgs,
  lpkgs,
  hostname,
  ...
}: {
  imports = [
    ./hmConfig/terminal
    ./hmConfig/desktop
    ./hosts/${hostname}/home.nix
    ./hosts/${hostname}/wm.nix
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
    cling
    speedtest-rs
    asciiquarium-transparent
    llvmPackages_21.clang-tools
    lldb_21
    pv
    just
    htop

    devenv
    sd
    diskus

    feh
  ];
  home.sessionVariables = {
    CPLUS_INCLUDE_PATH = "${lpkgs.dbg-macro}/usr/include";
  };

  home.file = {
    ".gdbinit".text = "set debuginfod enabled on";
  };
}
