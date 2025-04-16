{ nixpkgs, pkgs, config, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    lmstudio
  ];

}
