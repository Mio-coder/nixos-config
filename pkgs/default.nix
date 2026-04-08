final: prev: {
  dbg-macro = prev.callPackage ./dbg-macro.nix {};
  oiejq = prev.callPackage ./oiejq.nix {};
  html-to-markdown = prev.callPackage ./html-to-markdown.nix {};
  void-sddm = prev.callPackage ./void-sddm.nix {};
  pay-respects = prev.pay-respects.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        ./pay-respects.patch
      ];
  });
  bitwarden-thunderbird = prev.callPackage ./bitwarden_thunderbird.nix {};
  batsigal = prev.batsignal.overrideAttrs {
    patches = [./batsignal.patch];
  };
  progress-bar = prev.callPackage ./progress-bar.nix {};
}
