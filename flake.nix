{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    #nixpkgs.url = "nixpkgs/nixos-unstable";
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
  in {
    nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
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
            users."dwilliams" = import ./home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs;};
          };
        }
      ];
    };

    # Code formatter
    formatter.x86_64-linux = alejandra.defaultPackage.x86_64-linux;
  };
}
