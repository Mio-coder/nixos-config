_: {
  home.shellAliases = {
    # win = "docker compose --file ~/.config/winapps/compose.yaml";
    colorgrind = "valgrind -q ./a.out 2>&1 | sed -E \"s/alloc'd/alloc/g; s/==[0-9]+==//g\" | bat -plcpp --no-pager";
    alert = "notify-send --urgency=low -i \"$([ $? = 0 ] && echo terminal || echo error)\" \"$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')\"";
    loadsh = "source ~/.bashrc";

    # Make life a bit less stressful.
    mv = "mv -i";
    cp = "cp -i";
    rm = "rm -I";

    ".." = "cd ..";
    "..." = "cd ../..";

    ls = "ls --color=auto";
    ll = "ls -AlF";
    la = "ls -A";
    l = "ls -CF";

    # Colorific grep.
    grep = "grep --color=auto";

    # Colorific ip.
    ip = "ip --color=auto";

    # Runs bat without line numbers and wrapping.
    rat = "bat --style=plain --wrap=never";
  };
}
