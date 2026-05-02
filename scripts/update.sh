systemctl start --user lofi_download
nix flake update
./switch.sh
git push
bash -c "cd ~/code/zad/ && git push"
