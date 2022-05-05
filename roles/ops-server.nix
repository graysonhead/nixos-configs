{ nixpkgs, ... }:

{
    services.openssh.enable = true;
    security.sudo.wheelNeedsPassword = false;
    nix.requireSignedBinaryCaches = false;
}