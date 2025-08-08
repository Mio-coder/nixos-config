{pkgs, ...}: let
  format = pkgs.formats.yaml {};
  cfg = {
    feeds = [
      {
        url = "https://github.com/llvm/llvm-project/commits/main/clang/tools/clang-repl.atom";
      }
    ];
  };
in {
  home.packages = with pkgs; [
    nom
  ];
  xdg.configFile."nom/config.yml".source = format.generate "nom-config" cfg;

  systemd.user = {
    services.nom_refresh = {
      Unit = {
        Description = "Refresh rss feeds";
      };
      Service = {
        ExecStart = pkgs.writeShellScript "nom-update" ''
          nom refresh
        '';
      };
    };
    timers.nom_refresh = {
      Unit = {
        Description = "Refresh rss feeds";
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
  programs.bash.initExtra = ''
    count=$(nom unread 2>/dev/null)
    if [[ "$count" =~ ^[0-9]+$ ]] && [ "$count" -gt 0 ]; then
        echo "You have $count unread items."
    fi
  '';
}
