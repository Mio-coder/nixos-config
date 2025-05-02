{...}: {
  # fans
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
  services.thermald.enable = true;
  #  services.auto-cpureq.enable = true;
}
