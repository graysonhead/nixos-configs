{ nixpkgs, pkgs, config, ... }:

{
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
  ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
  };

  # Environment variables for AMD acceleration
  environment.variables = {
    HSA_OVERRIDE_GFX_VERSION = "11.0.0"; # Adjust for your GPU
  };

  users.users.grayson.extraGroups = [ "render" ];
}
