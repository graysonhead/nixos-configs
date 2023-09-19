{ nixpkgs, inputs, pkgs, config, ... }:
{
  powerManagement.powertop.enable = true;
  environment.systemPackages = with pkgs; [
    powertop
    lldpd
  ];
  services.lldpd.enable = true;
}
