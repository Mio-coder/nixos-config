{
  pkgs,
  config,
  lib,
  ...
}: {
  options.my.docker = lib.mkEnableOption "Docker backend";
  config = lib.mkMerge [
    (lib.mkIf config.my.docker {
      virtualisation.oci-containers.backend = "docker";
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;

        # i know it is decrepted but it keeps some legacy docker-compose files working
        enableNvidia = true;
      };
      users.users.mio.extraGroups = ["docker"];
    })
    (lib.mkIf (!config.my.docker) {
      virtualisation.oci-containers.backend = "podman";
      virtualisation.containers.enable = true;
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        enableNvidia = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      environment.systemPackages = with pkgs; [
        dive # look into docker image layers
        podman-tui # status of containers in the terminal
        docker-compose
        #podman-compose # start group of containers for dev
      ];
    })
  ];
}
