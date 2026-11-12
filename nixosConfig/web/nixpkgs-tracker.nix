{inputs, ...}: {
  imports = [
    inputs.nixpkgs-tracker.nixosModules.default
  ];
  services.nixpkgs-pr-tracker = {
    enable = true;
    tokenFile = "/var/lib/secrets/nixpkgs-pr-tracker-token";

    availableTargets = [
      "staging"
      "staging-next"
      "master"
      "nixos-unstable-small"
      "nixpkgs-unstable"
      "nixos-unstable"
      "nixos-26.05" # Example explicit stable branch; choose your release.
      "nixos-26.05-small"
    ];
    initialTargets = ["nixos-unstable"];
    # Default: checks at 00:00, 06:00, 12:00, 18:00, plus up to 5 minutes jitter.
    # refreshCalendar = "daily";
    # port = 8732;
  };
}
