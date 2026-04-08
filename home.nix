{
  pkgs,
  hostname,
  config,
  inputs,
  system,
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
    # Dev tools
    uv
    act
    alejandra
    python313Packages.ipython
    valgrind
    gdb
    gcc
    gnumake
    cling
    oiejq
    lldb_21
    llvmPackages_21.clang-tools
    just

    dbg-macro
    progress-bar

    # misc
    tldr
    undollar
    man-db
    pv
    htop
    speedtest-rs
    rsync
    feh
    cudatext
    clock-rs
    asciiquarium-transparent
    ncpamixer
    localsend
    libqalculate

    prismlauncher # takes long to download
    libreoffice
    miniserve
    ungoogled-chromium

    devenv
    sd
    diskus
    ripgrep-all

    (pkgs.writeShellScriptBin "szkopul-g++" ''
      ${inputs.nixpkgs-gcc.legacyPackages.${system}.gcc}/bin/g++ $@
    '')
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = [fzf nix-search-tv];
      text = ''
        nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history
      '';
    })

    # find a tool to unite them all, (tar, zstd, gzip, xz, 7z), preferibly parrarel
    unzip
  ];
  home.sessionVariables = {
    CPLUS_INCLUDE_PATH = with pkgs;
      lib.makeSearchPath "include" [
        dbg-macro
      ]
      + ":$CPLUS_INCLUDE_PATH";
  };

  home.file = {
    # I dont want to figure out where it points to
    "nix-bin".source = config.lib.file.mkOutOfStoreSymlink "/etc/profiles/per-user/mio/bin";
    ".nixos-config".source = inputs.self.outPath;
  };
}
