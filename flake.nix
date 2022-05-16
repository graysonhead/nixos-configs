{
  description = "Grayson's NixOS Configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    jager.url = "github:graysonhead/jager";
    deploy-rs.url = "github:serokell/deploy-rs";
    dns-agent.url = "/home/grayson/rust-projects/dns-agent";
  };
  outputs = { self, deploy-rs, nixpkgs, nixos-hardware, home-manager, jager, dns-agent, ... }: {
    nixosConfigurations = {
      deckchair = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.dell-xps-13-9370
          ./roles/plasma-desktop.nix
          ./systems/deckchair/configuration.nix
          ./jager/install.nix
        ];
        specialArgs = { inherit jager; inherit home-manager; inherit deploy-rs; inherit dns-agent; };
      };
      ops = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./roles/ops-server.nix
          ./systems/ops/configuration.nix
          ./services/dns-agent.nix
        ];
        specialArgs = { inherit home-manager; inherit deploy-rs; inherit dns-agent; };
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
