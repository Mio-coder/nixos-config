{
  pkgs,
  lib,
  ...
}: {
  config = {
    fonts.fontconfig.enable = true;
    home.packages = [
      pkgs.nerd-fonts.jetbrains-mono
    ];
  };
  options.my.font.propo = lib.mkOption {
    type = lib.types.str;
    default = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontPropo-Medium.ttf";
    readOnly = true;
    description = "Path to propo font.";
  };
}
