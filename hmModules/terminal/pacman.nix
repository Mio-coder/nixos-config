{pkgs, ...}: {
  # home.packages = with pkgs; [
  #   junest
  # ];
  home.sessionPath = [
    "~/.junest/usr/bin_wrappers/"
  ];
}
