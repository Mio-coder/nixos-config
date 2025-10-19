{pkgs, ...}: {
  home.packages = with pkgs; [
    (writeShellScriptBin "g--" ''
      ${gcc}/bin/g++ -O3 -Wall -Wextra -Wpedantic -Weffc++ -Wshadow -std=c++23 -DDEBUG -ggdb3 -g $@
    '')
    (writeShellScriptBin "gr" ''
      FILE="$1"
      DIR="$(dirname $FILE)"
      shift
      OUT="''${1:-$DIR/a.out}"
      shift
      ${gcc}/bin/g++ -O3 -Wall -Wextra -Wpedantic -Weffc++ -std=c++23 -DDEBUG -ggdb3 -g -o $OUT $@ $FILE && cat $DIR/in.txt | $OUT
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
