{pkgs, ...}: {
  home.packages = with pkgs; [
    (writeShellScriptBin "ish" ''
      # If no arguments → run interactive bash
      if [ $# -eq 0 ]; then
          exec bash -i
      fi

      # If first argument is -F and a path is provided
      if [ "$1" = "-F" ]; then
          if [ -n "$2" ]; then
              # Check if directory exists
              if [ -d "./$2" ]; then
                  cd "./$2" || exit 1
                  exec bash -i
              else
                  echo "Error: Directory '$2' does not exist."
                  exit 1
              fi
          else
              echo "Error: -F requires a path argument."
              exit 1
          fi
      fi

      # Otherwise → run dash with all arguments
      exec dash "$@"
    '')
    (writeShellScriptBin "g--" ''
      ${gcc}/bin/g++ -O0 -Wall -Wextra -Wpedantic -Weffc++ -Wshadow -std=c++23 -DDEBUG -ggdb3 -g $@
    '')
    (writeShellScriptBin "fds" ''
      dirs=$(${fd}/bin/fd -td -u -E \.git "$1")
      dir_count=$(echo "$dirs" | wc -l)

      if [[ $dir_count -eq 0 ]]; then
        echo "No folders found."
        return 1
      elif [[ $dir_count -eq 1 ]]; then
        dir=$(echo "$dirs" | head -n 1)
      else
        dir=$(echo "$dirs" | ${fzf}/bin/fzf --preview 'eza --tree | head -200')
      fi

      if [[ -n "$dir" ]]; then
        cd "$dir"
      fi
    '')
  ];
}
