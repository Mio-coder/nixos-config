{pkgs, ...}: let
  fhsArgs = {
    name = "fhs";
    profile = "export FHS=1";
    targetPkgs = pkgs:
      with pkgs;
        (appimageTools.defaultFhsEnvArgs.targetPkgs pkgs)
        ++ [
          glibc.static
          zlib.static
          libffi
          libtool
          musl
          gcc
        ];
  };
in {
  home.packages = with pkgs; [
    appimage-run
    (buildFHSEnv (appimageTools.defaultFhsEnvArgs // fhsArgs))
  ];
}
