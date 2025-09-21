{
  system,
  inputs,
  config,
  ...
}: {
  environment.systemPackages = [
    inputs.winapps.packages."${system}".winapps
    inputs.winapps.packages."${system}".winapps-launcher
  ];
  virtualisation.oci-containers.containers = {
    WinApps = {
      image = "ghcr.io/dockur/windows:latest";
      autoStart = false;
      environment = {
        VERSION = "11";
        RAM_SIZE = "4G";
        CPU_CORES = "4";
        DISK_SIZE = "64G";
        USERNAME = "MyWindowsUser";
        PASSWORD = "MyWindowsPassword";
        HOME = config.users.users.mio.home;
      };
      ports = [
        "8006:8006"
        "3389:3389/tcp"
        "3389:3389/udp"
      ];
      volumes = [
        "data:/storage"
        "${config.users.users.mio.home}:/shared"
        "${inputs.winapps.outPath}/oem:/oem:ro"
      ];
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--device=/dev/kvm"
        "--device=/dev/net/tun"
        "--stop-timeout=120"
      ];
    };
  };
  boot.kernelModules = ["kvm-intel" "tun"];
  users.users.mio.extraGroups = ["kvm"];
}
