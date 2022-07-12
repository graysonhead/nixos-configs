{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    mirroredBoots = [
      { devices = [ "nodev" ]; path = "/boot1"; efiSysMountPoint = "/boot1"; }
      { devices = [ "nodev" ]; path = "/boot2"; efiSysMountPoint = "/boot2"; }
    ];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];
  networking.hostName = "blue";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";
  system.stateVersion = "22.05";

}

