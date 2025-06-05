#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash alejandra git 
alejandra . -q || echo "alejandra not working" 1>&2
git add . || echo "git not working" 1>&2
sudo nixos-rebuild switch
