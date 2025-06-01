{...}: {
  networking = {
    hostName = "omen-nixos"; # Define your hostname.
    networkmanager.enable = true;
    hosts = {
      "10.14.87.141" = ["rpi.staszic"];
    };
    firewall = {
      allowedUDPPorts = [2757 2758 2759]; # Supertuxkart ports
      allowedUDPPortRanges = [
        {
          from = 2757;
          to = 2759;
        }
      ];
    };
  };
  users.users.mio.extraGroups = ["networkmanager"];
}
