{
  pkgs,
  lib,
  config,
  ...
}: {
  options.my.gnome = lib.mkEnableOption "gnome";
  config = lib.mkIf config.my.gnome {
    services = {
      xserver.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.shell.keybindings]
          switch-to-application-1=@as []
          switch-to-application-2=@as []
          switch-to-application-3=@as []
          switch-to-application-4=@as []
          switch-to-application-5=@as []
          switch-to-application-6=@as []
          switch-to-application-7=@as []
          switch-to-application-8=@as []
          switch-to-application-9=@as []

          [org.gnome.desktop.wm.keybindings]
          switch-to-workspace-1=['<super>1']
          switch-to-workspace-2=['<super>2']
          switch-to-workspace-3=['<super>3']
          switch-to-workspace-4=['<super>4']
          switch-to-workspace-5=['<super>5']
          switch-to-workspace-6=['<super>6']
          switch-to-workspace-7=['<super>7']
          switch-to-workspace-8=['<super>8']
          switch-to-workspace-9=['<super>9']
          move-to-workspace-1=['<super><shift>1']
          move-to-workspace-2=['<super><shift>2']
          move-to-workspace-3=['<super><shift>3']
          move-to-workspace-4=['<super><shift>4']
          move-to-workspace-5=['<super><shift>5']
          move-to-workspace-6=['<super><shift>6']
          move-to-workspace-7=['<super><shift>7']
          move-to-workspace-8=['<super><shift>8']
          move-to-workspace-9=['<super><shift>9']

          [org.gnome.desktop.wm.preferences]
          num-workspaces=9

          [org.gnome.mutter]
          dynamic-workspaces=false
        '';
      };
    };
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    environment.systemPackages = with pkgs; [
      xclip
    ];
    environment.gnome.excludePackages = with pkgs; [
      epiphany
      gnome-contacts
      gnome-logs
      gnome-maps
      gnome-system-monitor
      gnome-weather
    ];
  };
}
