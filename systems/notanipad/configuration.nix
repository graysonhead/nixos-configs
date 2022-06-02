# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  # https://bugzilla.kernel.org/show_bug.cgi?id=110941
  boot.kernelParams = [ "intel_pstate=no_hwp" ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Grub menu is painted really slowly on HiDPI, so we lower the
  # resolution. Unfortunately, scaling to 1280x720 (keeping aspect
  # ratio) doesn't seem to work, so we just pick another low one.
  boot.loader.grub.gfxmodeEfi = "1024x768";

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/20c1473c-55f3-4e0c-ad7e-0a906d8ae4b0";
      preLVM = true;
      allowDiscards = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  networking.hostName = "notanipad";
  networking.networkmanager = {
    enable=true;
  };

  time.timeZone = "America/Chicago";

  system.stateVersion = "21.11";
}

