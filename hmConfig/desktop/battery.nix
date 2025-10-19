{...}: {
  services.batsignal = {
    enable = true;
    extraArgs = [
      "-W"
      "\"Bettery <15% (~15 min)\""
      "-C"
      "\"Bettery <5% (~5 min)\""
      "-D"
      "\"Bettery <2% (~2 min)\""
    ];
  };
}
