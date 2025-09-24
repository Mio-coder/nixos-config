{pkgs, ...}: {
  home.packages = with pkgs; [
    (buildFHSEnv (appimageTools.defaultFhsEnvArgs
      // {
        name = "fhs";
        profile = ''export FHS=1'';
        runScript = writeShellScript "fhs-exec.sh" ''
          if [ $# -eq 0 ]; then
              exec bash
          else
              exec "$@"
          fi
        '';
      }))
  ];
}
