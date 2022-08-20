{ nixpkgs, pkgs, inputs, lib, ... }:

{
    environment.systemPackages = with pkgs; [
            gqrx
    ];
    hardware.rtl-sdr.enable = true;
}