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
      };
      users.users.mio.extraGroups = ["docker"];
    })
    (lib.mkIf (config.my.docker && config.my.nvidia.enable) {
      # i know it is decrepted but it keeps some legacy docker-compose files working
      virtualisation.docker.enableNvidia = true;
    })
  ];
}
