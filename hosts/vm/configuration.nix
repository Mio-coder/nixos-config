{...}: {
  imports = [./share_keys.nix ./dummy_user.nix];
  my = {
    # bluetooth = true;
    # vbox = true;
    # nvidia.enable = true;
    docker = true;
    dm = false;
  };
}
