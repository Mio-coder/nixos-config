{
  config,
  lib,
  ...
}: {
  options.my.kdeconnect = lib.mkEnableOption "KDE Connect";
  config = lib.mkIf config.my.kdeconnect {
    programs.kdeconnect.enable = true;
  };
}
