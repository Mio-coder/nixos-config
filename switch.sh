#!/usr/bin/env bash
alejandra . -q || true
sudo nixos-rebuild switch
