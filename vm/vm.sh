#/usr/bin/env bash
nixos-rebuild build-vm
rm omen-nixos.qcow2 || true
./result/bin/run-omen-nixos-vm
