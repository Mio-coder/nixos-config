{
  pkgs,
  inputs,
  hostname,
  system,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  config.home-manager = {
    extraSpecialArgs = {
      inherit inputs system hostname pkgs;
    };
    useUserPackages = true;
    useGlobalPkgs = true;
    users.mio = import ../../home.nix;
  };
}
