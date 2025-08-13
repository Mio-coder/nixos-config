{pkgs ? import <nixpkgs> {}}:
(pkgs.buildFHSEnv {
  name = "fhs-shell";
  runScript = "bash"; # opens bash inside the FHS env
  targetPkgs = p:
    with p; [
      nodejs_24
      python3
    ];
}).env
