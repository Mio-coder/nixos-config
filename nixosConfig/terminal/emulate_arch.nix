{
  config,
  lib,
  ...
}: {
  options.my.emulate = lib.mkEnableOption "Emulate aarch64";
  config = lib.mkIf config.my.emulate {
    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
