{
  description = "Grayson's NixOS Configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    jager.url = "github:graysonhead/jager";
    deploy-rs.url = "github:serokell/deploy-rs";
    dns-agent.url = "github:graysonhead/dns-agent";
    agenix.url = "github:ryantm/agenix";
  };
  outputs = { self,
              nixpkgs,
              agenix,
              deploy-rs,
              ... 
  }@inputs: {
    nixosConfigurations = {

      deckchair = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.nixos-hardware.nixosModules.dell-xps-13-9370
          ./roles/plasma-desktop.nix
          ./systems/deckchair/configuration.nix
          ./jager/install.nix
        ];
        specialArgs = { inherit inputs;};
      };

      ops = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          agenix.nixosModule
          ./roles/ops-server.nix
          ./systems/ops/configuration.nix
          ./services/dns-agent.nix
        ];
        specialArgs = { inherit inputs; };
      };

      nx1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          agenix.nixosModule
          ./systems/nx1/configuration.nix
          ./roles/minimal-server.nix
          ./services/dns-agent.nix
        ];
        specialArgs = { inherit inputs; };
      };

      factorio = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          agenix.nixosModule
          ./systems/factorio.nix
          ./roles/factorio.nix
        ];
        specialArgs = { inherit inputs; };
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
      nodes.nx1 = {
        hostname = "nx1.i.graysonhead.net";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nx1;
        };
      };

      nodes.factorio = {
        hostname = "factorio.i.graysonhead.net";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.factorio;
        };
      };

    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
