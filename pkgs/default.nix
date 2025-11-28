final: prev: {
  dbg-macro = prev.callPackage ./dbg-macro.nix {};
  oiejq = prev.callPackage ./oiejq.nix {};
  html-to-markdown = prev.callPackage ./html-to-markdown.nix {};
}
