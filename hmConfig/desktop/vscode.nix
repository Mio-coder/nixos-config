{pkgs, ...}: {
  programs.vscodium = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # vscodevim.vim
      ms-vscode.cpptools-extension-pack
    ];
  };
}
