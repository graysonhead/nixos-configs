{ nixpkgs, pkgs, inputs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    chirp
    gqrx
    direwolf
    audacity
  ];
  hardware.rtl-sdr.enable = true;
}
