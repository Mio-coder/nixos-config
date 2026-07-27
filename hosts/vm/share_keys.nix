{modulesPath, ...}: {
  imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];
  virtualisation.sharedDirectories.host-ssh = {
    source = "/etc/ssh";
    target = "/run/keys";
    securityModel = "none";
  };
  systemd.services.link-ssh-host-keys = {
    wantedBy = [ "multi-user.target" ];
    before = [ "sshd-keygen.service" "sshd.service" ];
    after = [ "local-fs.target" ];
  
    serviceConfig.Type = "oneshot";
  
    script = ''
      ln -sfn /run/keys/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
      ln -sfn /run/keys/ssh_host_rsa_key     /etc/ssh/ssh_host_rsa_key
    '';
  };
}
