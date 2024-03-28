{ nixpkgs, inputs, ... }:
{
  imports = [
    ./users.nix
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.grayson = {
    imports = [
      ./grayson-minimal.nix
    ];
    _module.args.inputs = inputs;
  };
}
