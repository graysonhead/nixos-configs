{ nixpkgs, inputs, ... }: 
{
    imports = [ 
        ./users.nix
        inputs.home-manager.nixosModules.home-manager
    ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.grayson = import ./grayson-minimal.nix;
}