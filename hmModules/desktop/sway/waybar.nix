{pkgs, ...}: {
  # waybar from https://github.com/antl-d/sway-dotfiles/blob/main/sway/config
  home.packages = with pkgs; [
    waybar
    mako
    pulsemixer
  ];
  home.file.".config/waybar".source = ./waybar;
}
