{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.kde = lib.mkEnableOption "kde";
  # config = lib.mkIf config.my.kde (
  #   # Example: https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/i3-sway/i3.nix
  #   let
  #     fakwin = pkgs.stdenv.mkDerivation {
  #       pname = "fakwin";
  #       version = "1.0.0";

  #       src = pkgs.fetchFromGitHub {
  #         owner = "DMaroo";
  #         repo = "fakwin";
  #         rev = "master";
  #         hash = "sha256-oEMSuy2NMbd3Q7wtGSVz9vrqNWFeZLrNDM3KAsLgUOw=";
  #       };

  #       nativeBuildInputs = [pkgs.cmake pkgs.qt6.wrapQtAppsHook];

  #       buildInputs = [pkgs.qt6.qtbase];

  #       installPhase = ''
  #         mkdir -p $out/bin
  #         cp fakwin $out/bin/
  #       '';

  #       meta = with pkgs.lib; {
  #         description = "A fake KWin dbus interface for Plasma6 running without KWin";
  #         license = licenses.mit;
  #         maintainers = ["DMaroo"];
  #         platforms = platforms.linux;
  #       };
  #     };
  #     keybinds = {
  #       "Mod4+Return" = "exec alacritty";
  #       "Mod4+Shift+q" = "kill";
  #       "Mod4+d" = "exec ${pkgs.kdePackages.plasma-workspace}/bin/krunner";

  #       "Mod4+h" = "focus left";
  #       "Mod4+j" = "focus down";
  #       "Mod4+k" = "focus up";
  #       "Mod4+l" = "focus right";

  #       "Mod4+Left" = "focus left";
  #       "Mod4+Down" = "focus down";
  #       "Mod4+Up" = "focus up";
  #       "Mod4+Right" = "focus right";

  #       "Mod4+Shift+h" = "move left";
  #       "Mod4+Shift+j" = "move down";
  #       "Mod4+Shift+k" = "move up";
  #       "Mod4+Shift+l" = "move right";

  #       "Mod4+Shift+Left" = "move left";
  #       "Mod4+Shift+Down" = "move down";
  #       "Mod4+Shift+Up" = "move up";
  #       "Mod4+Shift+Right" = "move right";

  #       "Mod4+b" = "splith";
  #       "Mod4+v" = "splitv";
  #       "Mod4+f" = "fullscreen toggle";
  #       "Mod4+a" = "focus parent";

  #       "Mod4+s" = "layout stacking";
  #       "Mod4+w" = "layout tabbed";
  #       "Mod4+e" = "layout toggle split";

  #       "Mod4+Shift+space" = "floating toggle";
  #       "Mod4+space" = "focus mode_toggle";

  #       "Mod4+1" = "workspace number 1";
  #       "Mod4+2" = "workspace number 2";
  #       "Mod4+3" = "workspace number 3";
  #       "Mod4+4" = "workspace number 4";
  #       "Mod4+5" = "workspace number 5";
  #       "Mod4+6" = "workspace number 6";
  #       "Mod4+7" = "workspace number 7";
  #       "Mod4+8" = "workspace number 8";
  #       "Mod4+9" = "workspace number 9";
  #       "Mod4+0" = "workspace number 10";

  #       "Mod4+Shift+1" = "move container to workspace number 1";
  #       "Mod4+Shift+2" = "move container to workspace number 2";
  #       "Mod4+Shift+3" = "move container to workspace number 3";
  #       "Mod4+Shift+4" = "move container to workspace number 4";
  #       "Mod4+Shift+5" = "move container to workspace number 5";
  #       "Mod4+Shift+6" = "move container to workspace number 6";
  #       "Mod4+Shift+7" = "move container to workspace number 7";
  #       "Mod4+Shift+8" = "move container to workspace number 8";
  #       "Mod4+Shift+9" = "move container to workspace number 9";
  #       "Mod4+Shift+0" = "move container to workspace number 10";

  #       "Mod4+Shift+minus" = "move scratchpad";
  #       "Mod4+minus" = "scratchpad show";

  #       "Mod4+Shift+c" = "reload";
  #       "Mod4+Shift+e" = "exec swaymsg exit";

  #       "Mod4+r" = "mode resize";
  #     };
  #   in {
  #     home.packages = [fakwin];

  #     systemd.user.services."fakwin" = {
  #       Unit = {
  #         Description = "Plasma Fake KWin dbus interface";
  #         After = ["multi-user.target"];
  #       };
  #       Install = {
  #         WantedBy = ["default.target"];
  #       };
  #       Service = {
  #         ExecStart = "${fakwin}/bin/fakwin";
  #         Slice = "session.slice";
  #         Restart = "on-failure";
  #       };
  #     };

  #     xdg.configFile."picom.conf".text = ''
  #       backend = "glx";
  #       blur-method = "dual_kawase";
  #       blur-devitation = true;
  #     '';
  #     # i3 configuration
  #     xsession.windowManager.i3 = {
  #       enable = true;
  #       config.keybindings = keybinds;
  #       extraConfig = ''
  #         # Plasma compatibility improvements
  #         for_window [window_role="pop-up"] floating enable
  #         for_window [window_role="task_dialog"] floating enable

  #         for_window [class="yakuake"] floating enable
  #         for_window [class="systemsettings"] floating enable
  #         for_window [class="plasmashell"] floating enable
  #         for_window [class="Plasma"] floating enable, border none
  #         for_window [title="plasma-desktop"] floating enable, border none
  #         for_window [title="win7"] floating enable, border none
  #         for_window [class="krunner"] floating enable, border none
  #         for_window [class="Kmix"] floating enable, border none
  #         for_window [class="Klipper"] floating enable, border none
  #         for_window [class="Plasmoidviewer"] floating enable, border none
  #         for_window [class="(?i)*nextcloud*"] floating disable
  #         for_window [class="plasmashell" window_type="notification"] border none, move position 70 ppt 81 ppt
  #         no_focus [class="plasmashell" window_type="notification"]

  #         # Kill desktop window (adjust title for your language)
  #         for_window [title="Desktop @ QRect.*"] kill, floating enable, border none
  #         for_window [title="Desktop — Plasma"] kill, floating enable, border none
  #         for_window [title="Arbeitsfläche — Plasma"] kill, floating enable, border none

  #         # Use Plasma's logout screen
  #         bindsym $mod+Shift+e exec --no-startup-id ${pkgs.kdePackages.kde-cli-tools}/bin/qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout -1 -1 -1

  #         # Audio controls
  #         bindsym XF86AudioRaiseVolume exec --no-startup-id ${pkgs.kdePackages.kde-cli-tools}/bin/qdbus org.kde.kglobalaccel /component/kmix invokeShortcut "increase_volume"
  #         bindsym XF86AudioLowerVolume exec --no-startup-id ${pkgs.kdePackages.kde-cli-tools}/bin/qdbus org.kde.kglobalaccel /component/kmix invokeShortcut "decrease_volume"
  #         bindsym XF86AudioMute exec --no-startup-id ${pkgs.kdePackages.kde-cli-tools}/bin/qdbus org.kde.kglobalaccel /component/kmix invokeShortcut "mute"
  #         bindsym XF86AudioMicMute exec --no-startup-id ${pkgs.kdePackages.kde-cli-tools}/bin/qdbus org.kde.kglobalaccel /component/kmix invokeShortcut "mic_mute"

  #         # Optional: Set background
  #         exec --no-startup-id ${pkgs.feh}/bin/feh --bg-scale ${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nix-wallpaper-simple-dark-gray.png

  #         # Optional: Picom compositor
  #         # exec --no-startup-id ${pkgs.picom}/bin/picom --experimental-backends -b

  #         focus_follows_mouse no
  #       '';
  #     };

  #     # systemd.user.services."plasma-i3wm" = {
  #     #   Unit = {
  #     #     Description = "Launch Plasma with i3wm.";
  #     #     After = ["graphical-session-pre.target" "plasma-workspace-x11.target"]; # Ensures proper startup order
  #     #   };
  #     #   Install = {
  #     #     WantedBy = ["plasma-workspace-x11.target"]; # Starts with Plasma X11 session
  #     #   };
  #     #   Service = {
  #     #     ExecStart = "${pkgs.i3}/bin/i3";
  #     #     Restart = "on-failure";
  #     #     Slice = "session.slice"; # Isolates in user session slice
  #     #   };
  #     # };
  #   }
  # );
}
