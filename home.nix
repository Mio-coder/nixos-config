{
  pkgs,
  hostname,
  config,
  ...
}: {
  imports = [
    ./hmConfig/terminal
    ./hmConfig/desktop
    ./hosts/${hostname}/home.nix
    ./hosts/${hostname}/wm.nix
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
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
    gdb
    rsync
    gnumake
    undollar
    libqalculate
    tldr
    cling
    speedtest-rs
    asciiquarium-transparent
    llvmPackages_21.clang-tools
    lldb_21
    pv
    just
    htop
    prismlauncher # takes long to download
    oiejq

    devenv
    sd
    diskus

    feh

    # find a tool to unite them all, (tar, zstd, gzip, xz, 7z), preferibly parrarel
    unzip
  ];
  home.sessionVariables = {
    CPLUS_INCLUDE_PATH = "${pkgs.dbg-macro}/usr/include";
  };

  # TODO: move .gdbinit to .config
  home.file = {
    ".gdbinit".text = ''
      set debuginfod enabled on
      set startup-with-shell off
    '';
    # I dont want to figure out where it points to
    "nix-bin".source = config.lib.file.mkOutOfStoreSymlink "/etc/profiles/per-user/mio/bin";
  };
}
