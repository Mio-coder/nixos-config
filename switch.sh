#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash alejandra git 
alejandra . -q
git add . || true
sudo nixos-rebuild switch
