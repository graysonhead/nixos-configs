{ nixpkgs, deploy-rs, ... }:

{
    services.openssh.enable = true;
    security.sudo.wheelNeedsPassword = false;
    nix.requireSignedBinaryCaches = false;
    environment.systemPackages = [
        deploy-rs.defaultPackage.x86_64-linux
    ];
}