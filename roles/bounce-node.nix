{ nixpkgs, inputs, pkgs, config, ... }:
{
  imports = [
    ../services/auto-dns.nix
  ];
}
