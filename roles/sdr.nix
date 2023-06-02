{ nixpkgs, pkgs, inputs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    gqrx
    direwolf
    audacity
  ];
  hardware.rtl-sdr.enable = true;
}
