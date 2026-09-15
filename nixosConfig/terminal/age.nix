{
  config,
  lib,
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

  # The SSH daemon can be disabled while agenix continues to use the
  # existing host identity to decrypt the login password.
  age.identityPaths = lib.mkIf (!config.my.sshServer) [
    "/etc/ssh/ssh_host_ed25519_key"
  ];
}
