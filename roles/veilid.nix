{ nixpkgs, inputs, pkgs, config, ... }:
{
  imports = [
  ];
  services.veilid = {
    enable = true;
    openFirewall = true;
  };
}
