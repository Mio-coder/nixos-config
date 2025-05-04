{
  lib,
  pkgs,
  ...
}: {
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

    shellAliases = {
      ipython = "uv tool run ipython";
      cling = "nix-shell -p cling --run cling";
      spython = "uv run --no-project --python-preference only-system --with sympy --with ipython -- ipython";
      win = "docker compose --file ~/.config/winapps/compose.yaml";
      colorgrind = "valgrind -q ./a.out 2>&1 | sed -E \"s/alloc'd/alloc/g; s/==[0-9]+==//g\" | bat -plcpp --no-pager";
      ll = "ls -AlF";
      la = "ls -A";
      l = "ls -CF";
      alert = "notify-send --urgency=low -i \"$([ $? = 0 ] && echo terminal || echo error)\" \"$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')\"";
      loadsh = "source ~/.bashrc";
      webstorm = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p jetbrains.webstorm --impure --run webstorm";
    };

    initExtra = ''
      # ~/.bashrc: executed by bash(1) for non-login shells.
      # see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
      # for examples

      # enable color support of ls and also add handy aliases
      if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
      fi
    '';
    logoutExtra = ''
      # when leaving the console clear the screen to increase privacy

      if [ "$SHLVL" = 1 ]; then
          [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
      fi
    '';
    sessionVariables = {
      GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
    };
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [
      "--hook=none"
    ];
  };
  home.packages = with pkgs; [
    (writeShellScriptBin "g--" ''
      g++ -O3 -Wall -Wextra -Wpedantic -Weffc++ -std=c++20 -DDEBUG -ggdb3 -g $@
    '')
    (writeShellScriptBin "gr" ''
      FILE="''$1"
      DIR="''$(dirname $FILE)"
      shift
      OUT="''${1:-$DIR/a.out}"
      shift
      g++ -O3 -Wall -Wextra -Wpedantic -Weffc++ -std=c++20 -DDEBUG -ggdb3 -g -o ''$OUT ''$@ ''$FILE && cat ''$DIR/in.txt | ''$OUT
    '')
    (writeShellApplication {
      name = "fds";
      runtimeInputs = [fzf fd];
      text = ''
        dirs=''$(fd -td -u "''$1")
        dir_count=''$(echo "''$dirs" | wc -l)

        if [[ ''$dir_count -eq 0 ]]; then
          echo "No folders found."
          return 1
        elif [[ ''$dir_count -eq 1 ]]; then
          dir=''$(echo "''$dirs" | head -n 1)
        else
          dir=''$(echo "''$dirs" | fzf --preview 'tree -C {} | head -200')
        fi

        if [[ -n "''$dir" ]]; then
          cd "''$dir"
        fi
      '';
    })
  ];
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "78543744+Mio-coder@users.noreply.github.com";
        name = "Mio-coder";
      };
    };
  };
}
