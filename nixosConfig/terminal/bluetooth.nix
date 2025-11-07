{
  config,
  lib,
  ...
}: {
  options.my.bluetooth = lib.mkEnableOption "bluetooth";
  config = lib.mkIf config.my.bluetooth {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
