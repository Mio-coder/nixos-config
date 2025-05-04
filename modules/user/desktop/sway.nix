{...}: {
  imports = [
    ./term.nix
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        {command = "alacritty";}
      ];
    };
  };
}
