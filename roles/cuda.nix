{ nixpkgs, inputs, pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
  ];
}
