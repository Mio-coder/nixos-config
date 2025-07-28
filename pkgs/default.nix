# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs, ...}: {
  # example = pkgs.callPackage ./example { };
  dbg-macro = pkgs.callPackage ./dbg-macro.nix {};
  oiejq = pkgs.callPackage ./oiejq.nix {};
}
