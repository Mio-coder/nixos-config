#! /usr/bin/env nix-shell
#! nix-shell -i dash -p dash alejandra git 
alejandra . -q
git add . || true
sudo nixos-rebuild switch --flake .
