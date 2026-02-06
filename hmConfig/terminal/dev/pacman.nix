{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.pacman = lib.mkEnableOption "Enable Junest";

  config = lib.mkIf config.my.pacman {
    # home.sessionPath = lib.mkOrder 2000 [
    #   "~/.junest/usr/bin_wrappers/"
    # ];
    home.sessionVariablesExtra = ''
      export PATH="$PATH:~/.junest/usr/bin_wrappers"
    '';
    home.packages = with pkgs; [
      junest
    ];
  };
}
