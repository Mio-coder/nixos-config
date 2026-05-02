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
    # misc
    tldr
    undollar
    man-db
    pv
    htop
    speedtest-go
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

    # devenv
    sd
    diskus
    dust
    ripgrep-all

    (pkgs.writeShellScriptBin "szkopul-g++" ''
      ${inputs.nixpkgs-gcc.legacyPackages.${system}.gcc}/bin/g++ $@
    '')

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
