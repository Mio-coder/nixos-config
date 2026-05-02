{
  config,
  pkgs,
  ...
}: {
  age.secrets.password.file = ../../secrets/password.age;
  users = {
    mutableUsers = false;
    users = {
      mio = {
        isNormalUser = true;
        description = "mio";
        extraGroups = ["wheel" "firejail"];
        hashedPasswordFile = config.age.secrets.password.path;
      };
      root = {
        hashedPasswordFile = config.age.secrets.password.path;
        shell = pkgs.dash;
      };
    };
    defaultUserShell = pkgs.dash;
  };
  environment.shells = [pkgs.dash];
}
