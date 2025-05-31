{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.virtualisation.windows-vm;
  userHome = config.users.users.${cfg.user}.home;
in {
  options.virtualisation.windows-vm = {
    enable = mkEnableOption "Windows VM using Docker container";

    user = mkOption {
      type = types.str;
      default = "winapps";
      description = "User to run the container (needs docker and kvm group access)";
    };

    ramSize = mkOption {
      type = types.str;
      default = "8G";
      description = "RAM allocated to the Windows VM";
    };

    cpuCores = mkOption {
      type = types.int;
      default = 4;
      description = "Number of CPU cores allocated";
    };

    timezone = mkOption {
      type = types.str;
      default = config.time.timeZone;
      description = "Timezone for the Windows VM";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open VNC (8006) and RDP (3389) ports";
    };

    isoPath = mkOption {
      type = types.path;
      example = "/path/to/windows.iso";
      description = "Path to Windows installation ISO file";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    virtualisation.oci-containers = {
      backend = "docker";
      containers.windows-vm = {
        image = "ghcr.io/dockur/windows:latest";
        autoStart = true;
        environment = {
          RAM_SIZE = cfg.ramSize;
          CPU_CORES = toString cfg.cpuCores;
          TZ = cfg.timezone;
        };
        ports = [
          "8006:8006" # VNC
          "3389:3389/tcp" # RDP
        ];
        volumes = [
          "windows-storage:/storage"
          "${userHome}/.config/winapps/storage/winapps:/storage/winapps:ro"
          "/tmp/.X11-unix:/tmp/.X11-unix:ro"
          "${cfg.isoPath}:/boot.iso:ro"
        ];
        extraOptions = [
          "--device=/dev/kvm"
          "--device=/dev/vhost-net"
          "--cap-add=NET_ADMIN"
        ];
      };
    };

    boot.kernelModules = ["ip_tables" "iptable_nat" "kvm-intel"];

    users.users.${cfg.user} = {
      isNormalUser = true;
      extraGroups = ["docker" "kvm"];
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [8006 3389];

    assertions = [
      {
        assertion = hasPrefix "x86_64" pkgs.system;
        message = "Windows VM requires x86_64 architecture";
      }
      {
        assertion = builtins.pathExists cfg.isoPath;
        message = "Windows ISO file not found at ${cfg.isoPath}";
      }
    ];
  };
}
