{
  inputs,
  pkgs,
  ...
}: let
  downloadsFuse = inputs.downloads-fuse.packages.${pkgs.system}.default;
in {
  home.packages = [downloadsFuse];

  systemd.user.services.downloads-fuse = {
    Unit = {
      Description = "Categorized Downloads FUSE filesystem";
      After = ["graphical-session-pre.target"];
    };

    Service = {
      Type = "simple";

      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/dl";
      ExecStart = "${downloadsFuse}/bin/downloads-fuse --source %h/Downloads --mount %h/dl";
      ExecStopPost = "-${pkgs.fuse3}/bin/fusermount3 -u %h/dl";

      Restart = "on-failure";
      RestartSec = 3;
    };

    Install.WantedBy = ["default.target"];
  };
}
