{ nixpkgs, home-manager, ... }: 
{
    imports = [ 
        ./users.nix
        home-manager.nixosModules.home-manager
    ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.grayson = import ./home-manager/grayson-minimal.nix;
}