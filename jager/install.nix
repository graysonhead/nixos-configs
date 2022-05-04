{ config, pkgs, jager, inputs, ...}:
let overlay-jager = final: prev: {
    jager = jager.packages;
    };
in
    {
    nixpkgs.overlays = [overlay-jager];
    environment.systemPackages = with pkgs; [
        jager.packages.${system}.jager-backend
    ];
    }
