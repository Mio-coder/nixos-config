{pkgs, ...}: {
  # wait for setting to stabilize
  home.packages = [
    pkgs.zed-editor
  ];
}
