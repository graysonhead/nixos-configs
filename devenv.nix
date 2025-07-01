{ inputs, pkgs, ... }:

{
  packages = [
    inputs.agenix.packages.x86_64-linux.agenix
    inputs.deploy-rs.packages.x86_64-linux.deploy-rs
    pkgs.nixpkgs-fmt
  ];

  git-hooks.hooks = {
    nixpkgs-fmt.enable = true;
    flake-check = {
      enable = true;
      name = "nix flake check";
      entry = "nix flake check";
      language = "system";
      pass_filenames = false;
    };
  };
}
