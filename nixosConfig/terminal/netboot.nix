{
  inputs,
  config,
  ...
}: let
  sys = inputs.nixpkgs-stable.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      (
        {
          modulesPath,
          lib,
          ...
        }: {
          imports = [
            (modulesPath + "/installer/netboot/netboot-minimal.nix")
          ];
          config = {
            services.getty.autologinUser = lib.mkForce "root";
            users.users.root.openssh.authorizedKeys.keys = [
              "AAAAC3NzaC1lZDI1NTE5AAAAIN7e36e3VVEv09BUoQ9pznnDRu0ma0tu8bEbzuAeqUQA"
              "AAAAC3NzaC1lZDI1NTE5AAAAIMz7v8TolMVBNSrX8r8Lvav2wyGEIWLi8sEWSeVXNLj3"
            ];
            system.stateVersion = "25.05";
          };
        }
      )
    ];
  };
  build = sys.config.system.build;
in {
  services.pixiecore = {
    enable = true;
    openFirewall = true;
    # dhcpNoBind = true; # use existing DHCP server
    port = 64172;
    statusPort = 64172;

    mode = "boot";
    kernel = "${build.kernel}/bzImage";
    initrd = "${build.netbootRamdisk}/initrd";
    cmdLine = "init=${build.toplevel}/init loglevel=4";
    debug = true;
  };
}
