{pkgs, ...}: let
  lib = pkgs.lib;
  listNixFiles = path: lib.lists.filter (f: (lib.strings.hasSuffix ".nix" f) && f != ./default.nix) (lib.filesystem.listFilesRecursive path);
in {
  imports = listNixFiles ./.;
}
