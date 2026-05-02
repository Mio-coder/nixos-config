{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      # "ssh://nix-ssh@10.0.0.1"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-ssh-cache-1:rfhTK/K9jVr5Kr19Ae5xapwt1BvrX0U18w8rsR+fnCU="
    ];
  };
  description = "Mio-coder's Nixos config";
  inputs = {
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-lunarvim.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-gcc.url = "github:nixos/nixpkgs/1634419f4f629111c7b66f370155a26d98c53505";
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
  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system overlays;
      config = {
        allowUnfree = true;
      };
    };

    overlays = let
      getPkgs = ch: inputs.${ch}.legacyPackages.${system};
    in [
      inputs.nur.overlays.default
      (final: prev: {
        inherit (getPkgs "nixpkgs-master") yt-dlp spotdl;
        inherit (getPkgs "nixpkgs-stable") firefox elinks;
        inherit (getPkgs "nixpkgs-lunarvim") lunarvim;
      })
      (import ./pkgs)
    ];

    customArgs = {
      inherit inputs system;
    };
    mkHost = hostname: let
      hostArgs =
        customArgs
        // {
          inherit hostname;
        };
    in
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs =
          hostArgs;
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            nixpkgs = {inherit overlays;};
            home-manager = {
              extraSpecialArgs =
                hostArgs
                // {
                  inherit pkgs;
                };
              useUserPackages = true;
              users.mio = import ./home.nix;
            };
          }
        ];
      };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      potato-nixos = mkHost "potato-nixos";
      omen-nixos = mkHost "omen-nixos";
    };
    # for hm news
    homeConfigurations."mio" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home.nix
      ];
      extraSpecialArgs =
        customArgs
        // {
          inherit pkgs;
          hostname = "omen-nixos";
        };
    };
    packages.${system} = {
      iso = let
        sys = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./hosts/iso.nix)
          ];
        };
      in
        sys.config.system.build.isoImage;
      dbg-macro = pkgs.dbg-macro;
    };
  };
}
