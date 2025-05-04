{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wget
    fd
    sl
    ripgrep
  ];
  environment.variables.EDITOR = "nvim";

  # flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
