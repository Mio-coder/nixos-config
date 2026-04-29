
nix eval .#nixosConfigurations.omen-nixos.config.system.build.toplevel.drvPath

nix-store --export $(nix-store --query --requisites "/nix/store/qi6lqs28s1r9rn2063snanmlalgbqxym-nixos-system-omen-nixos-26.05.20260422.0726a0e.drv") > ~/tmp/exported

cat exported | nix-store --import --option store /home/mio/tmp/tmp-store

nix-store --realise --max-jobs 0 --option store /home/mio/tmp/tmp-store /nix/store/qi6lqs28s1r9rn2063snanmlalgbqxym-nixos-system-omen-nixos-26.05.20260422.0726a0e.drv
