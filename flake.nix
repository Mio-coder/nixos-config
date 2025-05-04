{
  description = "A simple NixOs flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nix-flatpak,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "mio";
    flakeDir = "/home/${username}/nixos-config";

    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = {allowUnfree = true;};
    };
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      # overlays = [ ];
    };

    commonArgs = {
      inherit inputs system username flakeDir pkgs-stable;
      isNixos = true;
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
    mkHost = {hostname}:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = nixosSpecialArgs;
        modules = [
          # Host specific NixOS configuration
          ./hosts/${hostname}/configuration.nix

          # Common NixOS modules
          inputs.nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          # Home Manager configuration integrated into NixOS
          {
            home-manager = {
              extraSpecialArgs = homeManagerSpecialArgs;
              useUserPackages = true;
              backupFileExtension = "bak";
              users.${username} = import ./hosts/${hostname}/home.nix;
            };
          }
        ];
      };
    mkHome = {hostname}: {
      name = "${username}@${hostname}";
      value = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        extraSpecialArgs = homeManagerSpecialArgs;
        modules = [./hosts/${hostname}/home.nix];
      };
    };
  in {
    formatter.${system} = pkgs.alejandra;

    overlays = import ./overlays {inherit inputs self system;};

    nixosConfigurations = {
      omen-nixos = mkHost {hostname = "omen-nixos";};
    };
    homeConfigurations =
      builtins.listToAttrs [
        mkHome {hostname = "omen-debian";}
      ];
  };
}
