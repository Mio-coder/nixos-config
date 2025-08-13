{
  pkgs,
  lib,
  config,
  ...
}: {
  options.my.vnc = lib.mkEnableOption "VNC/XRDP desktop access";
  config = lib.mkIf config.my.vnc {
    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    services.xrdp.openFirewall = true;
    services.xrdp.port = 3391;
    services.xrdp.extraConfDirCommands = ''
      [Logging]
      LogFile=/var/log/xrdp.log
      LogLevel=DEBUG
      EnableSyslog=false
      SyslogLevel=DEBUG
    '';

    # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
    # If no user is logged in, the machine will power down after 20 minutes.
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;
  };
}
