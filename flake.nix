{
  description = "Grayson's NixOS Configurations";
  inputs = {
    home-manager.url = "github:nix-community/home-manager";
  };
  outputs = { nixpkgs, ... }: {
    nixosConfigurations = {
      deckchair = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./deckchair/configuration.nix
          ./modules/nix-flakes.nix
          ./modules/default-system-packages.nix
        ];
      };
    };
  };
}
