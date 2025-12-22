{...}: {
  networking.firewall.interfaces.eno1 = {
    allowedUDPPorts = [67 68];
  };
  networking.interfaces.eno1.ipv4.addresses = [
    {
      address = "10.0.1.1";
      prefixLength = 24;
    }
  ];
  networking.interfaces.eno1.useDHCP = false;
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "eno1";
      bind-interfaces = true;
      port = 0;
      dhcp-range = ["10.0.1.50,10.0.1.100,255.255.255.0,48h"];
      dhcp-option = [
        "option:dns-server,1.1.1.1,8.8.8.8"
      ];
    };
    resolveLocalQueries = false;
  };
  systemd.services.dnsmasq = {
    after = ["network-online.target"];
    requires = ["network-online.target"];
  };
  networking.networkmanager.unmanaged = ["eno1"];
}
