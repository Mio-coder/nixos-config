_: {
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower = {
    enable = true;
    criticalPowerAction = "Hibernate";
  };
  services.logind.settings.Login.HandleLidSwitch = "ignore";
}
