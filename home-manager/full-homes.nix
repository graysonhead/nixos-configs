{ nixpkgs, inputs, ... }:
{
  imports = [
    ./users.nix
    inputs.home-manager.nixosModules.default
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.grayson = {
    imports = [
      ./grayson.nix
      ./grayson-minimal.nix
    ];
    _module.args.inputs = inputs;
  };
  home-manager.users.maerose = import ./maerose.nix;
  home-manager.users.wyatt = import ./wyatt.nix;
  home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
}
