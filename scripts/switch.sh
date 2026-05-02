#!/usr/bin/env nix
#! nix shell nixpkgs#dash nixpkgs#alejandra nixpkgs#git --command dash
sudo true || true
alejandra . -q
git add . || true
nixos-rebuild switch --flake . -S $@
