{...}: {
  networking = {
    interfaces = {
      eno1 = {
        wakeOnLan.enable = true;
      };
    };
    firewall = {
      allowedUDPPorts = [9];
    };
  };
}
