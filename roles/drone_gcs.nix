{ nixpkgs, pkgs, inputs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    mission-planner
    mavproxy
    qgroundcontrol
    inav-configurator
    dfu-util
  ];
}
