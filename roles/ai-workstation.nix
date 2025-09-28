{ nixpkgs, pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    ollama
  ];

  # Environment variables for AMD acceleration
  environment.variables = {
    HSA_OVERRIDE_GFX_VERSION = "10.3.0"; # Adjust for your GPU
  };
}
