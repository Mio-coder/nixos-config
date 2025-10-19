{pkgs, ...}: {
  home.packages = with pkgs; [
    (elinks.override {
      enablePython = true;
      python = python3;
    })
  ];
  # TODO: once on stable config, move it in here
}
