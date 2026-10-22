{pkgs, ...}: {
  programs.anki = {
    enable = true;
    style = "anki";
    theme = "dark";
    addons = [
    ];
  };
}
