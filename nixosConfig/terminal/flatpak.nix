{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  options.my.flatpak = lib.mkEnableOption "Flatpak";
  config = lib.mkIf config.my.flatpak {
    services.flatpak.enable = true;
  };
}
