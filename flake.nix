{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  description = "A simple NixOs flake";
  inputs = {
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nur,
    agenix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "mio";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      overlays = [
        nur.overlays.default
        (final: prev: {
          yt-dlp = inputs.nixpkgs-master.legacyPackages.${system}.yt-dlp;
        })
      ];
    };

    customArgs = {
      inherit inputs system;
      lpkgs = import ./pkgs {inherit pkgs;};
    };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      potato-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs =
          customArgs
          // {
            hostname = "potato-nixos";
          };
        modules = [
          ./configuration.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs =
                customArgs
                // {
                  inherit pkgs;
                  hostname = "potato-nixos";
                };
              useUserPackages = true;
              backupFileExtension = "bak";
              users.${username} = import ./home.nix;
            };
            services.nixseparatedebuginfod2.enable = true;
            environment.systemPackages = [agenix.packages.${system}.default];
          }
        ];
      };
    };
    packages.${system}.news = let
      evaledHM = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };
    in
      evaledHM.config.news.json;
  };
}
