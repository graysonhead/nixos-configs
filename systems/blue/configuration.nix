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
    enableCryptodisk = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.yubikeySupport = true;
  boot.initrd.luks.devices = {
    encrypted_storage = {
      yubikey = {
        slot = 2;
        twoFactor = false;
        gracePeriod = 30;
        keyLength = 64;
        saltLength = 16;
        storage = {
          device = "/dev/disk/by-uuid/31ebf6c8-69a4-45fb-a03d-96afa820b6a7";
          fsType = "ext4";
          path = "/crypt-storage/default";
        };
      };
      device = "/dev/bcache0";
      preLVM = false;
    };
  };
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];
  networking.hostName = "blue";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  system.stateVersion = "22.05";
  networking.interfaces.enp6s0.useDHCP = true;
  networking.interfaces.enp11s0.useDHCP = false;
  networking.interfaces.br0.useDHCP = true;
  networking.bridges = {
      "br0" = {
          interfaces = [ "enp11s0" ];
          rstp = true;
      };
    };

}

