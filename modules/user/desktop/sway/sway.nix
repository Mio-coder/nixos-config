{...}: {
  imports = [
    ../term.nix
  ];
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    xwayland = true;
    systemd.enable = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        {command = "alacritty";}
      ];
    };
  };
  programs.wlogout.enable = true;
}
