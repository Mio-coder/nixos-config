{
  config,
  lib,
  pkgs,
  ...
}: {
  # based on https://github.com/catppuccin/hyprlock
  config = lib.mkIf config.my.sway {
    programs.hyprlock = {
      enable = true;
      settings = {
        font = "JetBrainsMono Nerd Font";

        general = {
          hide_cursor = true;
        };

        background = {
          monitor = "";
          path = "/nix/store/camkw1v81801jwfrdiyps2rhlhpvcbcx-sway-1.11/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png";
          blur_passes = 2;
          blur_size = 3;
          color = "rgba(46, 87, 111, 0.5)";
        };

        label = [
          {
            monitor = "";
            text = "$TIME";
            color = "rgb(cdd6f4)";
            font_size = 90;
            font_family = "JetBrainsMono Nerd Font";
            position = "-30, 0";
            halign = "right";
            valign = "top";
          }
          {
            monitor = "";
            text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
            color = "rgb(cdd6f4)";
            font_size = 25;
            font_family = "JetBrainsMono Nerd Font";
            position = "-30, -150";
            halign = "right";
            valign = "top";
          }
        ];

        "input-field" = {
          monitor = "";
          size = "320, 60";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgb(89b4fa)";
          inner_color = "rgba(46, 87, 111, 0.5)";
          font_color = "rgb(cdd6f4)";
          fade_on_empty = false;
          # text = "rgb(cdd6f4)";
          # textAlpha = "cdd6f4";
          # accent = "rgb(89b4fa)";
          # accentAlpha = "89b4fa";
          placeholder_text = ''<span foreground=#cdd6f4><i>󰌾 Logged in as </i><span foreground=#89b4fa>$USER</span></span>'';
          hide_input = false;
          check_color = "rgb(89b4fa)";
          fail_color = "rgb(f38ba8)";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = "rgb(f9e2af)";
          position = "0, -47";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
