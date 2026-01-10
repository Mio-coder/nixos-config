{...}: {
  my = {
    bluetooth = true;
    vbox = true;
    nvidia.enable = true;
  };
  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = ["on-the-go"];
      my.nvidia.external = false;
    };
  };
}
