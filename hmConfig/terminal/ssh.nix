_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "minionki" = {
        HostName = "minionki.staszic.waw.pl";
        IdentityFile = "~/.ssh/staszic";
      };
      "*" = {
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        IdentityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  home.file.".ssh/config" = {
    target = ".ssh/config_source";
    onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config'';
  };
}
