{
  # https://github.com/nix-community/disko/blob/master/example/simple-efi.nix
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B7785C5379E";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
