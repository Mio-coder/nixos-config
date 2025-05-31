{config, ...}: {
  age.secrets.password.file = ../../secrets/password.age;
  sers.users.mio = {
    isNormalUser = true;
    description = "mio";
    extraGroups = ["networkmanager" "wheel" "vboxusers"];
    hashedPasswordFile = config.age.secrets.password.path;
  };
}
