{
  config,
  lib,
  ...
}: {
  options.my.vbox = lib.mkEnableOption "Vbox";
  config = lib.mkIf config.my.vbox {
    virtualisation.virtualbox.host.enable = true;
    users.users.mio.extraGroups = ["vboxusers" "disk"];
  };
}
