{
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles.profiles = {
    "Static lan" = {
      connection = {
        id = "Static lan";
        type = "ethernet";
      };
      ethernet = {};
      ipv4 = {
        address1 = "10.0.0.2/8";
        ignore-auto-dns = "true";
        ignore-auto-routes = "true";
        may-fail = "false";
        method = "manual";
        never-default = "true";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
      proxy = {};
    };
  };
  services.getty.autologinUser = lib.mkForce "root";
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = true;
    };
  };
  services.logind.settings.Login.HandleLidSwitch = "ignore";
  environment.systemPackages = with pkgs; [btop-cuda nvim];
  # isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  isoImage.squashfsCompression = null;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host 10.0.0.1
        IdentityFile /etc/ssh/ssh_host_ed25519_key
    '';
  };
  nix.settings = {
    substituters = ["ssh://nix-ssh@10.0.0.1"];
    trusted-public-keys = ["nix-ssh-cache-1:rfhTK/K9jVr5Kr19Ae5xapwt1BvrX0U18w8rsR+fnCU="];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7e36e3VVEv09BUoQ9pznnDRu0ma0tu8bEbzuAeqUQA"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMz7v8TolMVBNSrX8r8Lvav2wyGEIWLi8sEWSeVXNLj3"
  ];
}
