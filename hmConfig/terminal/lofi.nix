{
  pkgs,
  lib,
  config,
  ...
}: let
  lofi_stats = with pkgs;
    writeShellApplication {
      name = "lofi_stats";
      runtimeInputs = [coreutils];
      text = ''
        STATE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}"
        mkdir -p "$STATE_DIR"
        download_count=1
        ((download_count++))
        while IFS= read -r line; do
            if [[ "$line" == Downloaded* ]]; then
                ((download_count++))
            fi
            echo "$line"
        done
        current_date=$(date +%F)
        echo "$current_date, $download_count" >> "$STATE_DIR/spotdl_stats.csv"
      '';
    };
  lofi_download = with pkgs;
    writeShellApplication {
      name = "lofi_download";
      runtimeInputs = [spotdl ffmpeg];
      text = ''
        spotdl download https://open.spotify.com/playlist/0vvXsWCC9xrXsKd4FyS8kM --format mp3 --skip-album-art --threads 12 --output ~/Music/lofi/ --yt-dlp-args "--cookies-from-browser firefox" | ${lofi_stats}/bin/lofi_stats
      '';
    };
  lofi = with pkgs;
    writeShellApplication {
      name = "lofi";
      runtimeInputs = [mpv];
      text =
        if config.my.lofi.download
        then ''
          exec mpv \
             ~/Music/lofi/ \
             --vid=no \
             --shuffle \
             --script=${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so
        ''
        else ''
          exec mpv https://www.youtube.com/watch?v=jfKfPfyJRdk \
             --vid=no \
             --script=${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so
        '';
    };
in {
  options.my.lofi.download = lib.mkEnableOption "download";
  config = {
    home.packages = with pkgs; [
      (writeShellScriptBin "lofi" ''
        if systemctl --user is-active --quiet lofi; then
            playerctl play
        else
            systemctl --user start lofi
        fi
        # heuristic for terminal
        if tty | grep -q pts; then
          journalctl --user -u lofi -f
        fi
      '')
      playerctl
    ];
    systemd.user = lib.mkMerge [
      (lib.mkIf config.my.lofi.download
        {
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
              Description = "Download latest lofi music";
            };
            Timer = {
              OnCalendar = "monthly";
              Persistent = true;
            };
            Install = {
              WantedBy = ["timers.target"];
            };
          };
        })
      {
        services.lofi = {
          Unit = {
            Description = "Play lofi music";
          };
          Service = {
            ExecStart = "${lofi}/bin/lofi";
          };
        };
      }
    ];
  };
}
