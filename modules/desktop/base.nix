{...}: {
  environment.systemPackages = with pkgs; [
    ungoogled-chromium
  ];
}
