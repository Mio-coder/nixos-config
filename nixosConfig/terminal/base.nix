{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    fd
    sl
    ripgrep
    btop-cuda
  ];
  environment.variables.EDITOR = "nvim";

  # flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # time
  services.chrony.enable = true;
}
