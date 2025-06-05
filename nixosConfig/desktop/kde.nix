{
  pkgs,
  lib,
  ...
}: {
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dex
        feh
        i3status
        picom
        rofi
      ];
    };
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    defaultSession = "plasmax11";
    sddm.enable = true;
  };
  systemd.user.services.plasma-i3wm = {
    wantedBy = ["plasma-workspace-x11.target"];
    description = "Launch Plasma with i3wm.";
    environment = lib.mkForce {};
    serviceConfig = {
      ExecStart = "${pkgs.i3}/bin/i3";
      Restart = "on-failure";
    };
  };
  systemd.user.services.plasma-workspace-x11.after = ["plasma-i3wm.target"];
  systemd.user.services.plasma-kwin_x11.enable = false;
  # Disable systemd boot for Plasma >=5.25
  environment.etc."xdg/startkderc".text = ''
    [General]
    systemdBoot=false
  '';

  # Important manual steps after deployment:
  # 1. Disable Meta+Q shortcut in Plasma Settings:
  #    Workspace > Shortcuts > System Services > Plasma > "Activities..." shortcut
  # 2. Adjust desktop window title in i3 config if needed
  # 3. Configure i3 bar if replacing Plasma panel
}
