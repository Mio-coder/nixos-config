{pkgs, ...}: {
  users.users.dummy = {
    shell = pkgs.bash;
    initialPassword = "123";
    extraGroups = ["video" "wheel"];
    isNormalUser = true;
  };
}
