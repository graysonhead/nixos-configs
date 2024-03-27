{ nixpkgs, inputs, pkgs, config, ... }:
{
  imports = [
    ../services/auto-dns.nix
    ../modules/common.nix
    ../home-manager/minimal-homes.nix
  ];
}
