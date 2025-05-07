{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    location = "top";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/w8ste/Tokyonight-rofi-theme/main/tokyonight.rasi";
      sha256 = "sha256:026wvrx5m05f530hwpmjx75g7khfsc69asmn2sg62xs3il6m5ryf";
    };
  };
}
