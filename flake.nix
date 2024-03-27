{
  description = "Grayson's NixOS Configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    jager.url = "github:graysonhead/jager";
    deploy-rs.url = "github:serokell/deploy-rs";
    dns-agent.url = "github:graysonhead/dns-agent";
    factorio-bot.url = "github:graysonhead/factoriobot";
    agenix.url = "github:ryantm/agenix";
    mach-nix.url = "github:DavHau/mach-nix";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
  };
  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
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
            agenix.nixosModules.age
            ./roles/plasma-desktop.nix
            ./roles/sdr.nix
            ./systems/chromebook/configuration.nix
            ./roles/laptop.nix
          ];
          specialArgs = { inherit inputs; };
        };

        blue = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            ./roles/blue.nix
            ./roles/libvirt.nix
            ./roles/ssh-server.nix
            ./roles/photoprism.nix
            ./systems/blue/configuration.nix
            ./roles/nix-substituter.nix
          ];
          specialArgs = { inherit inputs; };
        };

        deckchair = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            inputs.nixos-hardware.nixosModules.dell-xps-13-9370
            ./home-manager/full-homes.nix
            ./roles/plasma-desktop.nix
            ./systems/deckchair/configuration.nix
            ./roles/libvirt.nix
            ./jager/install.nix
            ./roles/sdr.nix
            ./roles/weylus.nix
            ./roles/remote-builders.nix
            ./roles/laptop.nix
          ];
          specialArgs = { inherit inputs; };
        };

        notanipad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            inputs.nixos-hardware.nixosModules.dell-precision-5530
            ./home-manager/full-homes.nix
            ./roles/plasma-desktop.nix
            ./systems/notanipad/configuration.nix
            ./roles/laptop.nix
          ];
          specialArgs = { inherit inputs; };
        };

        green = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            ./home-manager/full-homes.nix
            ./roles/plasma-desktop.nix
            ./systems/green/configuration.nix
            ./roles/ssh-server.nix
            ./roles/libvirt.nix
            ./roles/sdr.nix
            ./roles/cuda.nix
            ./roles/gamedev.nix
            ./roles/weylus.nix
            ./roles/nix-substituter.nix
            # ./roles/vr.nix
          ];
          specialArgs = { inherit inputs; };
        };
        mombox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            ./home-manager/full-homes.nix
            ./roles/plasma-desktop.nix
            ./roles/ssh-server.nix
            ./systems/mombox/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };
        factorio = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            ./systems/factorio.nix
            ./roles/factorio-server.nix
          ];
          specialArgs = { inherit inputs; };
        };
        bounce-ksfo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules= [
            agenix.nixosModules.age
            ./systems/ksfo-bounce/configuration.nix
            ./roles/bounce-node.nix
          ];
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
        nodes.bounce-ksfo = {
          hostname = "146.190.137.22";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.bounce-ksfo;
          };
        };
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
