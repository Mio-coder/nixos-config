{pkgs, ...}: {
  systemd.user = {
    services.media-mio-minionki-sshfs = {
      Unit = {
        Description = "Mount Minionki via SSHFS";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };

      Service = {
        ExecStart = ''
          ${pkgs.sshfs}/bin/sshfs \
          -o _netdev,ServerAliveInterval=30,ServerAliveCountMax=5,reconnect,IdentityFile=/home/mio/.ssh/staszic \
          mio@minionki:/home/k24_c/mio /home/mio/minionki -f
        '';
        ExecStop = "${pkgs.fuse}/bin/fusermount -u /home/mio/minionki";
        Restart = "on-failure";
        Type = "simple";
      };

      Install.WantedBy = ["default.target"];
    };
  };
}
