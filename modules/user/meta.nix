{
  pkgs,
  lib,
  isNixos ? false,
  ...
}: {
  nix = lib.mkDefault {
    gc = {
      automatic = true;
      frequency = "monthly";
    };
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
  nixpkgs =
    if isNixos
    then {}
    else {
      config.allowUnfree = true;
    };
}
