{ nixpkgs, ...}: {
    services.locate.enable = true;
    nixpkgs.config.allowUnfree = true;
}