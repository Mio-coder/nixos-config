{pkgs, ...}: {
  home.packages = with pkgs; [nix-index];
  programs.pay-respects.enable = true;
}
