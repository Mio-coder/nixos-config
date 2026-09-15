{
  config,
  lib,
  ...
}: {
  options.my.sshServer = lib.mkEnableOption "OpenSSH and Nix SSH serving";
  config = lib.mkIf config.my.sshServer {
    services.openssh.enable = true;
  };
}
