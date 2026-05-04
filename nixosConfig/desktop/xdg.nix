{...}: {
  environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

  # https://github.com/NixOS/nixpkgs/issues/189851#issuecomment-1238907955
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  '';
}
