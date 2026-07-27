{pkgs, ...}: {
  users.users.dummy = {
    shell = pkgs.bash;
    password = "123";
    extraGroups = [ "video" "wheel" ];
    group = "dummy";
    isSystemUser = true;
  };
  users.groups.dummy = {};
}
