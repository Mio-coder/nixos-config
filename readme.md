## My nixos configuration
work in progres
inspired by https://github.com/Rishabh5321/dotfiles

## Commands to install on encrypted partition
sudo cryptsetup luksOpen /dev/sda2 cryptroot
sudo mount /dev/mapper/lvmroot-root /mnt
sudo mount /dev/sda1 /mnt/boot
sudo nixos-install --flake .#omen-nixos

