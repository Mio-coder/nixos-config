{...}: {
  virtualisation.virtualbox.host.enable = true; # also move vboxusers group
  users.users.mio.extraGroups = ["vboxusers"];
}
