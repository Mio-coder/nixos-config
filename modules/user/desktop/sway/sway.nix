{pkgs, ...}: let
  default_keybinds = {
    "Mod4+Return" = "exec alacritty";
    "Mod4+Shift+q" = "kill";
    "Mod4+d" = "exec rofi -show run";

    "Mod4+h" = "focus left";
    "Mod4+j" = "focus down";
    "Mod4+k" = "focus up";
    "Mod4+l" = "focus right";

    "Mod4+Left" = "focus left";
    "Mod4+Down" = "focus down";
    "Mod4+Up" = "focus up";
    "Mod4+Right" = "focus right";

    "Mod4+Shift+h" = "move left";
    "Mod4+Shift+j" = "move down";
    "Mod4+Shift+k" = "move up";
    "Mod4+Shift+l" = "move right";

    "Mod4+Shift+Left" = "move left";
    "Mod4+Shift+Down" = "move down";
    "Mod4+Shift+Up" = "move up";
    "Mod4+Shift+Right" = "move right";

    "Mod4+b" = "splith";
    "Mod4+v" = "splitv";
    "Mod4+f" = "fullscreen toggle";
    "Mod4+a" = "focus parent";

    "Mod4+s" = "layout stacking";
    "Mod4+w" = "layout tabbed";
    "Mod4+e" = "layout toggle split";

    "Mod4+Shift+space" = "floating toggle";
    "Mod4+space" = "focus mode_toggle";

    "Mod4+1" = "workspace number 1";
    "Mod4+2" = "workspace number 2";
    "Mod4+3" = "workspace number 3";
    "Mod4+4" = "workspace number 4";
    "Mod4+5" = "workspace number 5";
    "Mod4+6" = "workspace number 6";
    "Mod4+7" = "workspace number 7";
    "Mod4+8" = "workspace number 8";
    "Mod4+9" = "workspace number 9";
    "Mod4+0" = "workspace number 10";

    "Mod4+Shift+1" = "move container to workspace number 1";
    "Mod4+Shift+2" = "move container to workspace number 2";
    "Mod4+Shift+3" = "move container to workspace number 3";
    "Mod4+Shift+4" = "move container to workspace number 4";
    "Mod4+Shift+5" = "move container to workspace number 5";
    "Mod4+Shift+6" = "move container to workspace number 6";
    "Mod4+Shift+7" = "move container to workspace number 7";
    "Mod4+Shift+8" = "move container to workspace number 8";
    "Mod4+Shift+9" = "move container to workspace number 9";
    "Mod4+Shift+0" = "move container to workspace number 10";

    "Mod4+Shift+minus" = "move scratchpad";
    "Mod4+minus" = "scratchpad show";

    "Mod4+Shift+c" = "reload";
    "Mod4+Shift+e" = "exec swaymsg exit";

    "Mod4+r" = "mode resize";
  };
in {
  imports = [
    ../term.nix
  ];
  home.packages = with pkgs; [
    posy-cursors # cursor theme
  ];
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    xwayland = true;
    systemd.enable = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "rofi";
      startup = [
        {command = "alacritty";}
        {
          command = "waybar";
          always = true;
        }
      ];
      bars = [];
      keybindings =
        default_keybinds
        // {
          # Brightness
          "--locked XF86MonBrightnessUp" = "exec brightnessctl set -- +1%";
          "--locked XF86MonBrightnessDown" = "exec brightnessctl set -- -1%";

          # Media control
          "--locked XF86AudioPlay" = "exec playerctl --player playerctld play-pause";
          "--locked XF86AudioNext" = "exec playerctl --player playerctld next";
          "--locked XF86AudioPrev" = "exec playerctl --player playerctld previous";

          "--locked XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "--locked XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "--locked XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        };
      seat = {
        "*" = {
          xcursor_theme = "Posy_Cursor 24";
        };
      };
    };
  };
}
