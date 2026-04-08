{...}: {
  my = {
    bluetooth = true;
    vbox = true;
    nvidia.enable = true;
    docker = true;
  };
  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = ["on-the-go"];
      my.nvidia.external = false;
      home-manager.users.mio = _: {
        my.autolock = true;
      };
    };
  };
}
