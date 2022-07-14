# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  # Use the systemd-boot EFI boot loader.

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.luks.yubikeySupport = true;
  boot.initrd.luks.devices = {
    root = {
      yubikey = {
        slot = 2;
        twoFactor = false;
        gracePeriod = 3;
        keyLength = 64;
        saltLength = 16;
        storage = {
          device = "/dev/nvme0n1p1";
          fsType = "vfat";
          path = "/crypt-storage/default";
        };
      };
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  #### NETWORKING
  networking.hostName = "deckchair"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

