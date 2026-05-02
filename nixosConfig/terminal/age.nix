{
  system,
  inputs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];
  environment.systemPackages = [
    inputs.agenix.packages.${system}.default
  ];
}
