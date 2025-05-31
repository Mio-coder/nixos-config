#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash alejandra git 
git add .
alejandra . -q || true
sudo nixos-rebuild switch
