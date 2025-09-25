{
  config,
  hostname,
  ...
}: {
  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
    };
    hosts = {
      "10.14.87.141" = ["rpi.staszic"];
    };
  };
  users.users.mio.extraGroups = ["networkmanager"];
}
