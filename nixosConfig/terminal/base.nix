{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    fd
    ripgrep
    btop
    jq
    file
  ];
  environment.variables.EDITOR = "nvim";

  # flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # time
  services.chrony.enable = true;
}
