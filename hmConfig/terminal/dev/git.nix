{lib, ...}: {
  programs.git = {
    enable = true;
    settings.user = {
      name = "Mio-coder";
      email = "78543744+Mio-coder@users.noreply.github.com";
    };
    signing.format = null;
  };

  programs.ssh = {
    enable = lib.mkDefault true;
    settings."github.com" = {
      IdentityFile = "~/.ssh/id_ed25519";
      User = "git";
    };
  };
}
