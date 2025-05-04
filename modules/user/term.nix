{
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    package = null;
    settings = {
      env.TERM = "xterm-256color";
      terminal.shell = "${pkgs.tmux}";

      font.normal.family = "0xProto Nerd Font Mono";

      window.decorations = "None";

      colors = {
        primary = {
          background = "#171421";
          bright_foreground = "#ffffff";
          foreground = "#d0cfcc";
        };

        normal = {
          black = "#171421";
          red = "#c01c28";
          green = "#26a269";
          yellow = "#a2734c";
          blue = "#12488b";
          magenta = "#a347ba";
          cyan = "#2aa1b3";
          white = "#d0cfcc";
        };

        bright = {
          black = "#5e5c64";
          red = "#f66151";
          green = "#33d17a";
          yellow = "#e9ad0c";
          blue = "#2a7bde";
          magenta = "#c061cb";
          cyan = "#33c7de";
          white = "#ffffff";
        };
      };
    };
  };
}
