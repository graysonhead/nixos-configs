{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "nx1";
  time.timeZone = "Chicago/America";
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  system.stateVersion = "21.11";
}
