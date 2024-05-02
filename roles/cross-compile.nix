{ nixpkgs, inputs, pkgs, config, ... }:
{
  nix.settings = {
    extra-platforms = [ "aarch64-linux" ];
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
