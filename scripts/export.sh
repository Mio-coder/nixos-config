DE="$(nix eval .#nixosConfigurations.omen-nixos.config.system.build.toplevel --raw)"
echo $DE
nix copy --to /mnt/nix/store/ --derivation $DE
