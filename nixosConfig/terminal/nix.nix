{
  config,
  pkgs,
  lib,
  ...
}: {
  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
      trusted-users = [
        "root"
        "mio"
      ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      secret-key-files = ["/etc/nix/signing-key.sec"];
    };
    optimise.automatic = true;
    # free up to 5GiB whenever there is less than 1GiB left
    extraOptions = let
      GiB = 1024 * 1024 * 1024;
    in ''
      min-free = ${toString GiB}
      max-free = ${toString (5 * GiB)}
    '';
    package = pkgs.nixVersions.git;
    # package = pkgs.lixPackageSets.stable.lix;
    sshServe = lib.mkIf config.my.sshServer {
      enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMFe4qGpEm/tPdufXpSCPHYOU9mkGdLRBrBaZ3PR8c7s root@nixos"
      ];
    };
  };
  nixpkgs.config.allowUnfree = lib.mkForce true;
}
