umount /nix/.rw-store -l && mount /dev/nvme0n1p5 /nix/.rw-store/
umount /nix/store -l && mount -t overlay overlay /nix/store -o rw,relatime,lowerdir=/nix/.ro-store,upperdir=/nix/.rw-store/store,workdir=/nix/.rw-store/work
nmtui
ssh-keygen
swapon /dev/nvme0n1p4
cat ./.ssh/id_ed25519.pub
# nix run disko#disko-install -- --flake .#omen-nixos --disk main /dev/nvme1n1
# https://github.com/nix-community/disko/blob/be1a6b8a05afdd5d5fa69fcaf3c4ead7014c9fd8/disko-install#L288C1-L289C99
