{
  lib,
  config,
  inputs,
  ...
}: {
  options.my.codex = lib.mkEnableOption "codex";
  config = lib.mkIf config.my.codex {
    programs.codex = {
      enable = true;
      skills = {
        i-have-adhd = lib.readFile (inputs.i-have-adhd + "/skills/i-have-adhd/SKILL.md");
      };
    };
  };
}
