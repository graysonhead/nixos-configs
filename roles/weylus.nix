{ nixpkgs, pkgs, inputs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    weylus
  ];
  networking.firewall = {
    allowedTCPPorts = [
      1701
      9001
    ];
  };
}
