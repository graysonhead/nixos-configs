{ nixpkgs, home-manager, deploy-rs, ... }: 
{
    imports = [ 
        ./users.nix 
        home-manager.nixosModules.home-manager
    ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.grayson = {
        imports = [
            ./grayson.nix
            ./grayson-minimal.nix
        ];
        _module.args.deploy-rs = deploy-rs;
    };
    home-manager.users.maerose = import ./maerose.nix;
}