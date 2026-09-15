{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.iphoneSupport = lib.mkEnableOption "iPhone USB support";
  config = lib.mkIf config.my.iphoneSupport {
    services.usbmuxd.enable = true;
    environment.systemPackages = with pkgs; [
      libimobiledevice
      ifuse
    ];
  };
}
