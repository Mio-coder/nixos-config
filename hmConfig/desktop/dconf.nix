# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  config,
  lib,
  ...
}:
with lib.hm.gvariant; {
  config = lib.mkIf config.my.gnome {
    dconf.settings = {
      "apps/seahorse/listing" = {
        keyrings-selected = ["gnupg://"];
      };

      "ca/desrt/dconf-editor" = {
        saved-pathbar-path = "/org/gnome/desktop/interface/color-scheme";
        saved-view = "/org/gnome/desktop/interface/color-scheme";
      };

      "org/gnome/Characters" = {
        recent-characters = ["\347" "\322" "\261"];
      };

      "org/gnome/Console" = {
        font-scale = 1.0;
      };

      "org/gnome/calculator" = {
        base = 10;
        button-mode = "basic";
        source-currency = "";
        source-units = "degree";
        target-currency = "";
        target-units = "radian";
      };

      "org/gnome/calendar" = {
        active-view = "month";
      };

      "org/gnome/clocks/state/window" = {
        panel-id = "world";
      };

      "org/gnome/control-center" = {
        last-panel = "wifi";
      };

      "org/gnome/desktop/a11y/applications" = {
        screen-reader-enabled = false;
      };

      "org/gnome/desktop/a11y/interface" = {
        show-status-shapes = false;
      };

      "org/gnome/desktop/a11y/magnifier" = {
        mag-factor = 1.0;
      };

      "org/gnome/desktop/app-folders" = {
        folder-children = ["Utilities" "YaST" "Pardus"];
      };

      "org/gnome/desktop/app-folders/folders/Pardus" = {
        categories = ["X-Pardus-Apps"];
        name = "X-Pardus-Apps.directory";
        translate = true;
      };

      "org/gnome/desktop/app-folders/folders/Utilities" = {
        apps = ["org.freedesktop.GnomeAbrt.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.font-viewer.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop"];
        categories = ["X-GNOME-Utilities"];
        name = "X-GNOME-Utilities.directory";
        translate = true;
      };

      "org/gnome/desktop/app-folders/folders/YaST" = {
        categories = ["X-SuSE-YaST"];
        name = "suse-yast.directory";
        translate = true;
      };

      "org/gnome/desktop/break-reminders/eyesight" = {
        play-sound = true;
      };

      "org/gnome/desktop/break-reminders/movement" = {
        duration-seconds = mkUint32 300;
        interval-seconds = mkUint32 1800;
        play-sound = true;
      };

      "org/gnome/desktop/input-sources" = {
        show-all-sources = false;
        sources = [(mkTuple ["xkb" "us"])];
        xkb-options = ["terminate:ctrl_alt_bksp"];
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        # cursor-size = 24;
        # cursor-theme = "breeze_cursors";
        enable-animations = true;
        font-antialiasing = "grayscale";
        font-name = "Noto Sans,  10";
        icon-theme = "breeze";
        overlay-scrolling = false;
        scaling-factor = mkUint32 1;
        show-battery-percentage = true;
        text-scaling-factor = 1.0;
        toolbar-style = "text";
      };

      "org/gnome/desktop/notifications" = {
        application-children = ["gnome-power-panel" "org-gnome-console" "org-gnome-characters" "chromium-browser" "firefox" "org-gnome-nautilus" "org-gnome-software"];
      };

      "org/gnome/desktop/notifications/application/chromium-browser" = {
        application-id = "chromium-browser.desktop";
      };

      "org/gnome/desktop/notifications/application/firefox" = {
        application-id = "firefox.desktop";
      };

      "org/gnome/desktop/notifications/application/gnome-power-panel" = {
        application-id = "gnome-power-panel.desktop";
      };

      "org/gnome/desktop/notifications/application/org-gnome-characters" = {
        application-id = "org.gnome.Characters.desktop";
      };

      "org/gnome/desktop/notifications/application/org-gnome-console" = {
        application-id = "org.gnome.Console.desktop";
      };

      "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
        application-id = "org.gnome.Nautilus.desktop";
      };

      "org/gnome/desktop/notifications/application/org-gnome-software" = {
        application-id = "org.gnome.Software.desktop";
      };

      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = false;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        two-finger-scrolling-enabled = true;
      };

      "org/gnome/desktop/search-providers" = {
        sort-order = ["org.gnome.Settings.desktop" "org.gnome.Contacts.desktop" "org.gnome.Nautilus.desktop"];
      };

      "org/gnome/desktop/session" = {
        idle-delay = mkUint32 0;
      };

      "org/gnome/desktop/sound" = {
        theme-name = "ocean";
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "icon:minimize,maximize,close";
        focus-mode = "mouse";
      };

      "org/gnome/epiphany" = {
        ask-for-default = false;
      };

      "org/gnome/epiphany/state" = {
        is-maximized = false;
      };

      "org/gnome/evince" = {
        document-directory = "file:///home/mio/Downloads";
      };

      "org/gnome/evince/default" = {
      };

      "org/gnome/evolution-data-server" = {
        migrated = true;
      };

      "org/gnome/file-roller/listing" = {
        list-mode = "as-folder";
        show-path = false;
        sort-method = "name";
        sort-type = "ascending";
      };

      "org/gnome/file-roller/ui" = {
      };

      "org/gnome/maps" = {
        map-type = "MapsVectorSource";
        transportation-type = "pedestrian";
        zoom-level = 2;
      };

      "org/gnome/mutter" = {
        attach-modal-dialogs = false;
        center-new-windows = false;
        edge-tiling = false;
      };

      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "icon-view";
        migrated-gtk-settings = true;
        search-filter-time-type = "last_modified";
      };

      "org/gnome/nautilus/window-state" = {
      };

      "org/gnome/nm-applet/eap/9ba0e32d-ae3b-3dec-af09-bcd75812f8eb" = {
        ignore-ca-cert = false;
        ignore-phase2-ca-cert = false;
      };

      "org/gnome/portal/filechooser/chromium-browser" = {
        last-folder-path = "/home/mio/Downloads";
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = false;
        night-light-schedule-automatic = false;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        power-button-action = "interactive";
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-battery-type = "nothing";
      };

      "org/gnome/shell" = {
        command-history = ["busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart(\"Restarting\8230\")'" "restart" "r"];
        disable-user-extensions = false;
        disabled-extensions = ["windowsNavigator@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "system-monitor@gnome-shell-extensions.gcampax.github.com" "status-icons@gnome-shell-extensions.gcampax.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "light-style@gnome-shell-extensions.gcampax.github.com" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "apps-menu@gnome-shell-extensions.gcampax.github.com" "auto-move-windows@gnome-shell-extensions.gcampax.github.com"];
        enabled-extensions = ["pop-shell@system76.com"];
        last-selected-power-profile = "performance";
        welcome-dialog-last-shown-version = "47.2";
      };

      "org/gnome/shell/extensions/pop-shell" = {
        active-hint = false;
        gap-inner = mkUint32 1;
        gap-outer = mkUint32 1;
        tile-by-default = true;
      };

      "org/gnome/shell/world-clocks" = {
        locations = [];
      };

      "org/gnome/software" = {
        first-run = false;
      };

      "org/gnome/tweaks" = {
        show-extensions-notice = false;
      };

      "org/gtk/gtk4/settings/file-chooser" = {
        date-format = "regular";
        location-mode = "path-bar";
        show-hidden = false;
        sort-column = "name";
        sort-directories-first = true;
        sort-order = "ascending";
        type-format = "category";
        view-type = "list";
      };

      "org/gtk/settings/file-chooser" = {
        date-format = "regular";
        location-mode = "path-bar";
        show-hidden = true;
        show-size-column = true;
        show-type-column = true;
        sidebar-width = 182;
        sort-column = "name";
        sort-directories-first = false;
        sort-order = "descending";
        type-format = "category";
      };
    };
  };
}
