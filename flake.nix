{
  description = "Grayson's NixOS Configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    jager.url = "/home/grayson/RustProjects/jager";
  };
  outputs = { nixpkgs, nixos-hardware, home-manager, jager, ... }: {
    nixosConfigurations = {
      deckchair = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.dell-xps-13-9370
          ./deckchair/configuration.nix
          ./users.nix
          ./modules/nix-flakes.nix
          ./modules/default-system-packages.nix
          ./desktop-manager/plasma.nix
          ./services/syncthing.nix
          ./services/common.nix
          ./jager/install.nix
	  home-manager.nixosModules.home-manager
		{
			home-manager.useGlobalPkgs = true;
			home-manager.useUserPackages = true;
			home-manager.users.grayson = import ./home-manager/grayson.nix;
		}
        ];
        specialArgs = { inherit jager; };
      };
    };
  };
}
