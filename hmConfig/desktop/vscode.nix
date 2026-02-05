{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # vscodevim.vim
      ms-vscode.cpptools-extension-pack
    ];
  };
}
