{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "qr" ''
      ${pkgs.qrencode}/bin/qrencode -t ANSI256UTF8 $@
    '')
  ];
}
