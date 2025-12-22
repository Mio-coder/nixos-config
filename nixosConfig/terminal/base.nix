{pkgs, ...}: {
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

  # time
  services.chrony.enable = true;
}
