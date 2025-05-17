#!/usr/bin/env bash
alejandra . || true
sudo nixos-rebuild switch
