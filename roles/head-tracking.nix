{ nixpkgs, inputs, pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    opentrack
    aitrack
  ];
}
