{
  inputs,
  system,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    package = inputs.nixpkgs-stable.legacyPackages.${system}.mesa;
  };
}
