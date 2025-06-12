{
  config,
  pkgs,
  lib,
  ...
}: {
  options.my.kde = lib.mkEnableOption "kde";
  config = lib.mkIf config.my.kde {
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.defaultSession = "plasmax11";
    services.desktopManager.plasma6.enable = true;
    services.xserver.windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3status
      ];
    };
  };
}
