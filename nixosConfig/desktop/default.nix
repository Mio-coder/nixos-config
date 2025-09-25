{
  pkgs,
  lib,
  ...
}: let
  listNixFiles = path: lib.lists.filter (f: lib.strings.hasSuffix ".nix" f) (lib.filesystem.listFilesRecursive path);
in {
  imports = lib.lists.remove ./default.nix (listNixFiles ./.);

  config.environment.systemPackages = with pkgs; [
    ungoogled-chromium
  ];
}
