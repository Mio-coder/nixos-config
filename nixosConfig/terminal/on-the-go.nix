{lib, ...}: {
  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = ["on-the-go"];
      my.nvidia.external = lib.mkForce false;
      home-manager.users.mio = _: {
        my.autolock = lib.mkForce true;
      };
    };
  };
}
