{pkgs, ...}: {
  programs.sway = {
    enable = true;
    wrapperFeatures = {
      gtk = true;
    };
  };
  security.polkit.enable = true;
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
