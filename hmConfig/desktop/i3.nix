{ config, lib, pkgs, ... }:
{
  options.my.i3 = lib.mkEnableOption "i3 window manager (home)";

  config = lib.mkIf config.my.i3 {
    home.packages = with pkgs; [
      rofi
      playerctl
      brightnessctl
      pulseaudio # for pactl client
    ];

    xsession.enable = true;
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "alacritty";
        menu = "rofi -show drun";
        keybindings = {
          # App launchers
          "Mod4+Return" = "exec alacritty";
          "Mod4+d" = "exec rofi -show drun";

          # Focus (Pop!_OS style hjkl + arrows)
          "Mod4+h" = "focus left";
          "Mod4+j" = "focus down";
          "Mod4+k" = "focus up";
          "Mod4+l" = "focus right";
          "Mod4+Left" = "focus left";
          "Mod4+Down" = "focus down";
          "Mod4+Up" = "focus up";
          "Mod4+Right" = "focus right";

          # Move windows
          "Mod4+Shift+h" = "move left";
          "Mod4+Shift+j" = "move down";
          "Mod4+Shift+k" = "move up";
          "Mod4+Shift+l" = "move right";
          "Mod4+Shift+Left" = "move left";
          "Mod4+Shift+Down" = "move down";
          "Mod4+Shift+Up" = "move up";
          "Mod4+Shift+Right" = "move right";

          # Layout / tiling controls similar to Pop Shell
          "Mod4+b" = "splith";
          "Mod4+v" = "splitv";
          "Mod4+f" = "fullscreen toggle";
          "Mod4+Shift+space" = "floating toggle";
          "Mod4+space" = "focus mode_toggle";
          "Mod4+s" = "layout stacking";
          "Mod4+w" = "layout tabbed";
          "Mod4+e" = "layout toggle split";

          # Workspaces (1-10)
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

          # Scratchpad
          "Mod4+minus" = "scratchpad show";
          "Mod4+Shift+minus" = "move scratchpad";

          # Session
          "Mod4+Shift+c" = "reload";
          "Mod4+Shift+q" = "kill";
          "Mod4+r" = "mode resize";

          # Media keys (PulseAudio via pactl, playerctl)
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPause" = "exec playerctl pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioStop" = "exec playerctl stop";

          # Brightness keys (prefer brightnessctl over xbacklight)
          "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        };
      };
    };
  };
}
