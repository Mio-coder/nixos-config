{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519";
        user = "git";
      };
      "minionki" = {
        hostname = "minionki.staszic.waw.pl";
        identityFile = "~/.ssh/staszic";
      };
    };
  };
}
