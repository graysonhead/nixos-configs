{
  description = "Grayson's NixOS Configurations";
  outputs = { nixpkgs, ... }: {
    nixosConfigurations = {
      deckchair = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./deckchair/configuration.nix
        ];
      };
    };
  };
}
