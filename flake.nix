{
  description = "Grayson's NixOS Configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    jager.url = "github:graysonhead/jager";
    deploy-rs.url = "github:serokell/deploy-rs";
  };
  outputs = { self, deploy-rs, nixpkgs, nixos-hardware, home-manager, jager, ... }: {
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
        ];
        specialArgs = { inherit jager; inherit home-manager; };
      };
      ops = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./roles/ops-server.nix
          ./ops/configuration.nix
          ./users.nix
          ./modules/nix-flakes.nix
          ./modules/default-system-packages.nix
          ./services/common.nix
          home-manager.nixosModules.home-manager
        ];
        specialArgs = { inherit jager; inherit home-manager; inherit deploy-rs; };
      };
    };
    deploy = {
      nodes.ops = {
        hostname = "ops.i.graysonhead.net";
        profiles.system = {
          sshUser = "grayson";
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ops;
        };
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
