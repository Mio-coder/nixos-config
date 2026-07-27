{...}: {
  imports = [./share_keys.nix ./dummy_user.nix];
  # The Windows container runs its own QEMU guest and WireGuard needs /dev/net/tun.
  boot.kernelModules = ["kvm-intel" "tun"];
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  my = {
    # bluetooth = true;
    # vbox = true;
    # nvidia.enable = true;
    docker = true;
    dm = false;
  };
}
