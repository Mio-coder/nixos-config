{
  config,
  lib,
  ...
}: {
  options.my.vbox = lib.mkEnableOption "Vbox";
  config = lib.mkIf config.my.vbox {
    virtualisation.virtualbox.host.enable = true; # also move vboxusers group
    users.users.mio.extraGroups = ["vboxusers"];
  };
}
