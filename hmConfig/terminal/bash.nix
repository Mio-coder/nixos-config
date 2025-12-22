{...}: {
  programs.lesspipe.enable = true;
  programs.bash = {
    enable = true;

    historyControl = ["ignoreboth"];
    historySize = 1000;
    historyFileSize = 2000;
    enableCompletion = true;
    historyIgnore = [
      "l"
      "ll"
      "ls"
      ".."
      "..."
    ];

    initExtra = ''
      if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      fi
    '';
    sessionVariables = {
      LESS = "-R -X";
    };
  };
  home.shell.enableBashIntegration = true;
  programs.gcc = {
    enable = true;
    package = null;
    colors = {
      error = "01;31";
      warning = "01;35";
      note = "01;36";
      caret = "01;32";
      locus = "01";
      quote = "01";
    };
  };
}
