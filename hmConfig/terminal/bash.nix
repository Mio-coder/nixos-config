{pkgs, ...}: {
  programs.lesspipe.enable = true;
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batgrep
      batman
      batpipe
      batdiff
      prettybat
    ];
  };
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
      GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
      LESS = "-R -X";
    };
  };
  programs.zoxide = {
    enable = true;
    options = [
      "--hook=none"
    ];
  };
  home.shell.enableBashIntegration = true;
  home.packages = with pkgs; [
    (writeShellScriptBin "g--" ''
      ${pkgs.gcc}/bin/g++ -O3 -Wall -Wextra -Wpedantic -Weffc++ -std=c++20 -DDEBUG -ggdb3 -g $@
    '')
    (writeShellScriptBin "gr" ''
      FILE="$1"
      DIR="$(dirname $FILE)"
      shift
      OUT="''${1:-$DIR/a.out}"
      shift
      ${pkgs.gcc}/bin/g++ -O3 -Wall -Wextra -Wpedantic -Weffc++ -std=c++20 -DDEBUG -ggdb3 -g -o $OUT $@ $FILE && cat $DIR/in.txt | $OUT
    '')
    (writeShellScriptBin "fds" ''
      dirs=$(${fd}/bin/fd -td -u "$1")
      dir_count=$(echo "$dirs" | wc -l)

      if [[ $dir_count -eq 0 ]]; then
        echo "No folders found."
        return 1
      elif [[ $dir_count -eq 1 ]]; then
        dir=$(echo "$dirs" | head -n 1)
      else
        dir=$(echo "$dirs" | ${fzf}/bin/fzf --preview 'tree -C {} | head -200')
      fi

      if [[ -n "$dir" ]]; then
        cd "$dir"
      fi
    '')
  ];
}
