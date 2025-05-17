{...}: {
  programs.git = {
    enable = true;
    userName = "Mio-coder";
    userEmail = "78543744+Mio-coder@users.noreply.github.com";
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519";
        user = "git";
      };
    };
  };
}
