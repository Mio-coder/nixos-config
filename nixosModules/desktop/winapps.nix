{
  system,
  inputs,
  ...
}: {
  nix.settings = {
    substituters = ["https://winapps.cachix.org/"];
    trusted-public-keys = ["winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g="];
  };

  environment.systemPackages = [
    inputs.winapps.packages."${system}".winapps
    inputs.winapps.packages."${system}".winapps-launcher
  ];
}
