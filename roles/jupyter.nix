{ nixpkgs, pkgs, inputs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
  ];
  service.jupyter = {
    user = "test";
    password = "test";
  };
  services.jupyter.kernels.
  }
