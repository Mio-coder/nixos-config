{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.i3 = lib.mkEnableOption "i3 window manager (system)";

  config = lib.mkIf config.my.i3 {
    services.xserver = {
      enable = true;
      layout = "us";
      displayManager.lightdm.enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
          i3lock
        ];
      };
    };
  };
}
