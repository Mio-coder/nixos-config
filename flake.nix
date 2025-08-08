{
  description = "A simple NixOs flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
      overlays = [nur.overlays.default];
    };

    commonArgs = {
      inherit inputs system username;
      isNixos = true;
      lpkgs = import ./pkgs {inherit pkgs;};
    };

    nixosSpecialArgs =
      commonArgs
      // {
        inherit home-manager;
        inherit self;
        outputs = self;
      };
    homeManagerSpecialArgs =
      commonArgs
      // {
        inherit self pkgs;
      };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      omen-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = nixosSpecialArgs;
        modules = [
          ./configuration.nix
          # Common NixOS modules
          inputs.nix-flatpak.nixosModules.nix-flatpak
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          # Home Manager configuration integrated into NixOS
          {
            home-manager = {
              extraSpecialArgs = homeManagerSpecialArgs;
              useUserPackages = true;
              backupFileExtension = "bak";
              users.${username} = import ./home.nix;
            };
          }
          {
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
