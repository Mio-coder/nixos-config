_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "minionki" = {
        hostname = "minionki.staszic.waw.pl";
        identityFile = "~/.ssh/staszic";
      };
      "*" = {
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
  home.file.".ssh/config" = {
    target = ".ssh/config_source";
    onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config'';
  };
}
