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
    sl
    ripgrep
    (
      if config.my.nvidia
      then btop-cuda
      else btop
    )
  ];
  environment.variables.EDITOR = "nvim";

  # flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # time
  services.chrony.enable = true;
}
