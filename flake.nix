{
  description = "Grayson's NixOS Configurations";
  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs = { nixpkgs, nixos-hardware, ... }: {
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
        ];
      };
    };
  };
}
