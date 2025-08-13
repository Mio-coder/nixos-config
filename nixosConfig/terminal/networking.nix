{config, ...}: {
  networking = {
    hostName = "potato-nixos";
    networkmanager = {
      enable = true;
    };
    hosts = {
      "10.14.87.141" = ["rpi.staszic"];
    };
  };
  users.users.mio.extraGroups = ["networkmanager"];
}
