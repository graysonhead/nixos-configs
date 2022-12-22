{
  description = "Grayson's NixOS Configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    jager.url = "github:graysonhead/jager";
    deploy-rs.url = "github:serokell/deploy-rs";
    dns-agent.url = "github:graysonhead/dns-agent";
    factorio-bot.url = "github:graysonhead/factoriobot";
    agenix.url = "github:ryantm/agenix";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
  };
  outputs =
    { self
    , nixpkgs
    , agenix
    , deploy-rs
    , ...
    }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          agenix.packages.x86_64-linux.agenix
          deploy-rs.packages.x86_64-linux.deploy-rs
          nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt
        ];
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      nixosConfigurations = {

        chromebook = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModule
            ./roles/plasma-desktop.nix
            ./roles/sdr.nix
            ./systems/chromebook/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };

        blue = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModule
            ./roles/blue.nix
            ./roles/libvirt.nix
            ./systems/blue/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };

        deckchair = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModule
            inputs.nixos-hardware.nixosModules.dell-xps-13-9370
            ./home-manager/full-homes.nix
            ./roles/plasma-desktop.nix
            ./systems/deckchair/configuration.nix
            ./jager/install.nix
            ./roles/sdr.nix
            ./roles/gamedev.nix
          ];
          specialArgs = { inherit inputs; };
        };

        notanipad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModule
            inputs.nixos-hardware.nixosModules.dell-precision-5530
            ./home-manager/full-homes.nix
            ./roles/plasma-desktop.nix
            ./systems/notanipad/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };

        green = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModule
            ./home-manager/full-homes.nix
            ./roles/plasma-desktop.nix
            ./systems/green/configuration.nix
            ./roles/sdr.nix
            ./roles/cuda.nix
            ./roles/gamedev.nix
          ];
          specialArgs = { inherit inputs; };
        };


        mombox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModule
            ./home-manager/full-homes.nix
            ./roles/plasma-desktop.nix
            ./systems/mombox/configuration.nix
          ];
          specialArgs = { inherit inputs; };
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
            ./roles/factorio-server.nix
          ];
          specialArgs = { inherit inputs; };
        };

      };
      deploy = {

        nodes.blue = {
          hostname = "blue.i.graysonhead.net";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.blue;
          };
        };

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
