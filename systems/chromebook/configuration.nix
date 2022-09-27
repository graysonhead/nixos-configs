# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/mmc-016GE2_0xa12f4284-part1"; 

  networking.networkmanager.enable = true;
  networking.hostName = "chromebook";

  time.timeZone = "America/Chicago";

  system.stateVersion = "22.05"; # Did you read the comment?

}

