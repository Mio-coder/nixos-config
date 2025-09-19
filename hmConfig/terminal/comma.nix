{inputs, ...}: {
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];
  programs.nix-index-database.comma.enable = true;
  programs.nix-index = {
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };
  programs.pay-respects.enable = true;
  xdg.configFile."pay-respects/config.toml".text = ''
    install_method = "Shell"
  '';
  programs.command-not-found.enable = false;
}
