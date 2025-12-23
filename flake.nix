{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alejandra.url = "github:kamadorueda/alejandra";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixvim,
    noctalia,
    alejandra,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    
  in {
    # expose both so other modules can use them
    legacyPackages.${system} = { inherit pkgs pkgs-unstable; };
    nixosConfigurations.PD-TJ19380NLV = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./config/nh.nix
        ./modules/drivers/default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users."princedimond" = import ./home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs;};
          };
        }
      ];
      specialArgs = {
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
        };
      };
    };

    # Code formatter
    formatter.x86_64-linux = alejandra.defaultPackage.x86_64-linux;
  };
}
