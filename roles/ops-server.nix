{ nixpkgs, deploy-rs, ... }:

{
    imports = [ 
        ../home-manager/minimal-homes.nix
        ../modules/common.nix
        ../services/common.nix 
        ];
    services.openssh.enable = true;
    security.sudo.wheelNeedsPassword = false;
    environment.systemPackages = [
        deploy-rs.defaultPackage.x86_64-linux
    ];
}