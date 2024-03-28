{ nixpkgs, pkgs, config, ... }:
{
  imports = [
    ../home-manager/minimal-homes.nix
    ../services/auto-dns.nix
    ../modules/common.nix
  ];
}
