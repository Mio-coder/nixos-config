{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.my.nvidia.enable == false) {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
