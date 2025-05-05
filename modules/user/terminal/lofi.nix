{
  isNixos,
  pkgs,
  ...
}: let
  lofi_download = with pkgs;
    writeShellApplication {
      name = "lofi_download";
      runtimeInputs = [spotdl ffmpeg];
      text = ''
        cd ~/Music/lofi/
        spotdl download https://open.spotify.com/playlist/0vvXsWCC9xrXsKd4FyS8kM --format mp3 --threads 12
      '';
    };
in {
  home.packages =
    [
      (pkgs.writeShellScriptBin "lofi" ''
        mocp -x 2> /dev/null || true
        mocp -S && mocp -o shuffle -a ~/Music/lofi -p
      '')
    ]
    ++ (
      if isNixos
      then [pkgs.moc]
      else []
    );
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
  };
}
