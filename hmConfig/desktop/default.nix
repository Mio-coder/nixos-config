{pkgs, ...}: let
  lib = pkgs.lib;
  listNixFiles = path: lib.lists.filter (f: lib.strings.hasSuffix ".nix" f) (lib.filesystem.listFilesRecursive path);
in {
  imports = lib.lists.remove ./search.nix (lib.lists.remove ./default.nix (listNixFiles ./.));
}
