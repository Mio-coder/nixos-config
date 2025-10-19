{
  pkgs,
  lib,
  ...
}: {
  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://nixos-raspberrypi.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];
      trusted-users = ["root" "mio"];
      auto-optimise-store = true;
    };
    optimise = {
      automatic = true;
    };
    # free up to 1GiB whenever there is less than 100MiB left
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
    package = pkgs.nixVersions.git;
  };

  nixpkgs.config.allowUnfree = lib.mkForce true;
}
