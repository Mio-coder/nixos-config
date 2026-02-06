{lib, ...}: {
  programs.git = {
    enable = true;
    settings.user = {
      name = "Mio-coder";
      email = "78543744+Mio-coder@users.noreply.github.com";
    };
  };

  programs.ssh = {
    enable = lib.mkDefault true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519";
        user = "git";
      };
    };
  };
}
