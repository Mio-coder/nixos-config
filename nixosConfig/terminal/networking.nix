{hostname, ...}: {
  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
      ensureProfiles.profiles = {
        "Static lan" = {
          connection = {
            id = "Static lan";
            type = "ethernet";
          };
          ethernet = {};
          ipv4 = {
            address1 = "10.0.0.1/8";
            ignore-auto-dns = "true";
            ignore-auto-routes = "true";
            may-fail = "false";
            method = "manual";
            never-default = "true";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = {};
        };
      };
    };
    hosts = {
      "10.14.87.141" = ["rpi.staszic"];
      "10.14.70.11" = ["sio2.staszic"];
    };
  };
  users.users.mio.extraGroups = ["networkmanager"];
}
