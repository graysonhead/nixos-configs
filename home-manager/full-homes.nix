{ nixpkgs, inputs, ... }:
{
  imports = [
    ./users.nix
    inputs.home-manager.nixosModule
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
}
