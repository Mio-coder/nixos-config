{
  pkgs,
  lib,
  config,
  ...
}: {
  options.my.gnome = lib.mkEnableOption "gnome";
  config = lib.mkIf config.my.gnome {
    programs.gnome-shell = {
      enable = true;
      extensions = [
        {package = pkgs.gnomeExtensions.pop-shell;}
      ];
    };
    home.pointerCursor = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 32;
      gtk.enable = true;
    };
  };
}
