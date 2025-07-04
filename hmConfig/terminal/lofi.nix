{pkgs, ...}: let
  lofi_stats = with pkgs;
    writeShellApplication {
      name = "lofi_stats";
      runtimeInputs = [coreutils];
      text = ''
        # Get state directory from XDG environment variable or use default
        STATE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}"

        # Create directory if it doesn't exist
        mkdir -p "$STATE_DIR"

        # Initialize download counter
        download_count=1
        ((download_count++))

        # # Process input line by line
        while IFS= read -r line; do
            if [[ "$line" == Downloaded* ]]; then
                ((download_count++))
            fi
            echo "$line"
        done

        # Get current date in YYYY-MM-DD format
        current_date=$(date +%F)

        # Log to file in XDG state directory
        echo "$current_date, $download_count" >> "$STATE_DIR/spotdl_stats.csv"
      '';
    };
  lofi_download = with pkgs;
    writeShellApplication {
      name = "lofi_download";
      runtimeInputs = [spotdl ffmpeg];
      text = ''
        spotdl download https://open.spotify.com/playlist/0vvXsWCC9xrXsKd4FyS8kM --format mp3 --threads 12 --output ~/Music/lofi/ | ${lofi_stats}/bin/lofi_stats
      '';
    };
  lofi_play = with pkgs;
    writeShellApplication {
      name = "lofi_play";
      runtimeInputs = [mpv];
      text = ''
        exec mpv \
           ~/Music/lofi/ \
           --vid=no \
           --shuffle \
           --script=${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so
      '';
    };
in {
  home.packages = with pkgs; [
    (writeShellScriptBin "lofi" ''
      if systemctl --user is-active --quiet lofi_play; then
          playerctl play
      else
          systemctl --user start lofi_play
      fi
      journalctl --user -u lofi_play -f
    '')
    playerctl
  ];
  systemd.user = {
    services.lofi_download = {
      Unit = {
        Description = "Download latest lofi music";
      };
      Service = {
        ExecStart = "${lofi_download}/bin/lofi_download";
      };
    };
    timers.lofi_download = {
      Unit = {
        Description = "Download latest lofi music daily";
      };
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install = {
        WantedBy = ["timers.target"];
      };
    };
    services.lofi_play = {
      Unit = {
        Description = "Play lofi music";
      };
      Service = {
        ExecStart = "${lofi_play}/bin/lofi_play";
        Restart = "always";
      };
    };
  };
}
