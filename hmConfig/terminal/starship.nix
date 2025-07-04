_: {
  programs.starship = {
    enable = true;
    settings = {
      format = "$username$hostname$directory$nix_shell$git_branch$git_state$git_status$python$custom$cmd_duration$env_var$character";

      nix_shell = {
        format = "[$name]($style) ";
        style = "green";
        disabled = false;
      };

      env_var.FHS = {
        format = "[fhs](purple) ";
      };

      directory = {
        style = "blue";
      };

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style) ";
        style = "cyan";
        stashed = "≡";
      };

      git_state = {
        format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };

      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
      };
    };
  };
}
