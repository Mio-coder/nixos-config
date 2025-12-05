{
  pkgs,
  hostname,
  config,
  inputs,
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
    gcc
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
    feh
    tridactyl-native
    clock-rs
    miniserve

    devenv
    sd
    diskus
    ripgrep-all

    # find a tool to unite them all, (tar, zstd, gzip, xz, 7z), preferibly parrarel
    unzip
  ];
  home.sessionVariables = {
    CPLUS_INCLUDE_PATH = "${pkgs.dbg-macro}/usr/include";
  };

  home.file = {
    # I dont want to figure out where it points to
    "nix-bin".source = config.lib.file.mkOutOfStoreSymlink "/etc/profiles/per-user/mio/bin";
    ".nixos-config".source = inputs.self.outPath;
  };
}
