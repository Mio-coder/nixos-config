{lib, ...}: {
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = ["root" "mio"];
    auto-optimise-store = true;
  };
  nix.optimise = {
    automatic = true;
  };

  nixpkgs.config.allowUnfree = lib.mkForce true;
  # free up to 1GiB whenever there is less than 100MiB left
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';
}
