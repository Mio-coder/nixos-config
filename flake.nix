{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  description = "Mio-coder's Nixos config";
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
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        inputs.nur.overlays.default
        (final: prev: {
          yt-dlp = inputs.nixpkgs-master.legacyPackages.${system}.yt-dlp;
          spotdl = inputs.nixpkgs-master.legacyPackages.${system}.spotdl;
          firefox = inputs.nixpkgs-stable.legacyPackages.${system}.firefox;
        })
        (import ./pkgs)
      ];
    };

    customArgs = {
      inherit inputs system;
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
          inputs.agenix.nixosModules.default
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
              users.mio = import ./home.nix;
            };
            services.nixseparatedebuginfod2.enable = true;
            environment.systemPackages = [inputs.agenix.packages.${system}.default];
          }
        ];
      };
    };
    # for hm news
    packages.${system} = {
      homeConfigurations."mio" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs =
          customArgs
          // {
            inherit pkgs;
            hostname = "potato-nixos";
          };
      };
      iso = let
        sys = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ({
              lib,
              modulesPath,
              pkgs,
              ...
            }: {
              imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
              networking.networkmanager.enable = true;
              services.getty.autologinUser = lib.mkForce "root";
              services.openssh = {
                enable = true;
                settings.PasswordAuthentication = false;
              };
              services.logind.settings.Login.HandleLidSwitch = "ignore";
              environment.systemPackages = with pkgs; [btop-cuda];
              # isoImage.squashfsCompression = "gzip -Xcompression-level 1";
              # isoImage.squashfsCompression = null;
              nix.settings.experimental-features = ["nix-command" "flakes"];
              users.users.root.openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7e36e3VVEv09BUoQ9pznnDRu0ma0tu8bEbzuAeqUQA"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMz7v8TolMVBNSrX8r8Lvav2wyGEIWLi8sEWSeVXNLj3"
              ];
            })
          ];
        };
      in
        sys.config.system.build.isoImage;
    };
  };
}
