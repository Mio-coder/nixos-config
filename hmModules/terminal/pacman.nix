{pkgs, ...}: {
  # home.sessionPath = [
  #   "~/.junest/usr/bin_wrappers/"
  # ];
  home.packages = with pkgs; [
    junest
  ];
}
