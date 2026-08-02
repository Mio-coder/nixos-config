{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.my.media.enable {
    my.docker = true;

    # Wait until Windows is actually reachable through both advertised services.
    systemd.services."windows-vpn-ready" = {
      description = "Wait for Windows VPN VM to become ready";
      after = [
        "docker-windows_vpn.service"
      ];
      requires = [
        "docker-windows_vpn.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = [pkgs.netcat];
      script = ''
        until nc -z -w 2 172.30.0.2 22; do
          sleep 2
        done
      '';
      wantedBy = ["multi-user.target"];
    };
  };
}
