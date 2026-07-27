{...}: {
  imports = [./share_keys.nix ./dummy_user.nix];
  # The Windows container runs its own QEMU guest and WireGuard needs /dev/net/tun.
  boot.kernelModules = ["kvm-intel" "tun"];
  my = {
    # bluetooth = true;
    # vbox = true;
    # nvidia.enable = true;
    docker = true;
    dm = false;
  };
}
