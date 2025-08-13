{config, ...}: {
  # age.secrets.password.file = ../../secrets/password.age;
  users.mutableUsers = false;
  users.users.mio = {
    isNormalUser = true;
    description = "mio";
    extraGroups = ["wheel"];
    # hashedPasswordFile = config.age.secrets.password.path;
    initialPassword = "mio123"; # what were you expecting?
  };
}
