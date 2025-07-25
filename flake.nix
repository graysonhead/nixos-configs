{
  description = "Grayson's NixOS Configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:graysonhead/nixpkgs/factorio-rcon-args";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    deploy-rs.url = "github:serokell/deploy-rs";
    dns-agent.url = "github:graysonhead/dns-agent";
    factorio-bot.url = "github:graysonhead/factoriobot";
    agenix.url = "github:ryantm/agenix";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , agenix
    , deploy-rs
    , pre-commit-hooks
    , ...
    }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    rec
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        inherit (self.checks.x86_64-linux.pre-commit-check) shellHook;
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
            ./roles/factorio-server.nix
          ];
          specialArgs = { inherit inputs; };
        };

        # Mostly Retired
        # deckchair = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [
        #     agenix.nixosModules.age
        #     inputs.nixos-hardware.nixosModules.dell-xps-13-9370
        #     ./home-manager/full-homes.nix
        #     inputs.nixos-cosmic.nixosModules.default
        #     # ./roles/cosmic-desktop.nix
        #     ./roles/plasma-desktop.nix
        #     ./systems/deckchair/configuration.nix
        #     ./roles/libvirt.nix
        #     ./roles/sdr.nix
        #     ./roles/weylus.nix
        #     ./roles/cross-compile.nix
        #     ./roles/remote-builders.nix
        #     ./roles/laptop.nix
        #   ];
        #   specialArgs = { inherit inputs; };
        # };

        skippy = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            inputs.nixos-hardware.nixosModules.framework-13-7040-amd
            ./home-manager/full-homes.nix
            ./roles/plasma-desktop.nix
            ./systems/skippy/configuration.nix
            ./roles/libvirt.nix
            ./roles/sdr.nix
            ./roles/cross-compile.nix
            #./roles/remote-builders.nix
            ./roles/laptop.nix
            ./roles/steam.nix
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
            #./roles/cuda.nix
            ./roles/gamedev.nix
            #./roles/weylus.nix
            ./roles/lm-notebook.nix
            ./roles/cross-compile.nix
            ./roles/nix-substituter.nix
            ./roles/vr.nix
            ./roles/steam.nix
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
          specialArgs = { inherit inputs; };
          modules = [
            agenix.nixosModules.age
            ./roles/bounce-node.nix
            ./systems/ksfo-bounce/configuration.nix
          ];
        };
        hal = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            ./modules/common.nix
            ./home-manager/minimal-homes.nix
            ./roles/ssh-server.nix
            ./services/auto-dns.nix
            ./roles/ai-gateway.nix
            ./systems/hal/configuration.nix
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
        nodes.bounce-ksfo = {
          hostname = "bounce-ksfo.i.graysonhead.net";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.bounce-ksfo;
          };
        };
        nodes.hal = {
          hostname = "hal.i.graysonhead.net";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hal;
          };
        };
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib // {
        x86_64-linux = (deploy-rs.lib.x86_64-linux.deployChecks self.deploy) // {
          pre-commit-check = pre-commit-hooks.lib.x86_64-linux.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
            };
          };
        };
      };
    };
}
