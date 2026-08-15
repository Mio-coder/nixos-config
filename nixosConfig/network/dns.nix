{...}: {
  services.tailscale = {
    enable = true;
  };

  services.resolved = {
    enable = true;

    dnsDelegates."sio2" = {
      Delegate = {
        DNS = ["127.0.0.1:5353"];

        Domains = [
          "sio2.staszic.waw.pl"
          "sio2.local"
          "sio2"
        ];
      };
    };
  };
  services.dnsmasq = {
    enable = true;

    # Important: resolved remains the system resolver.
    resolveLocalQueries = false;

    settings = {
      # Don't collide with systemd-resolved on port 53.
      port = 5353;
      listen-address = "127.0.0.1";
      bind-interfaces = true;

      # DNS servers learned by NetworkManager, before the
      # systemd-resolved stub is substituted.
      resolv-file = "/run/NetworkManager/no-stub-resolv.conf";

      clear-on-reload = true;
    };
  };
}
