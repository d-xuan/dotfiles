{
  inputs = {
    # System packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Disk-configuration for new hosts
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User package and dotfiles
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, disko, home-manager, ... }@inputs:
    let

      globals = {
        username = "wednesday";
        secrets = import ./secrets/secrets.nix;
      };

    in {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {

        system = "x86_64-linux";
        specialArgs = {
          inherit globals;
          inherit inputs;
        };

        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          ./configuration.nix
        ];
      };
    };
}
