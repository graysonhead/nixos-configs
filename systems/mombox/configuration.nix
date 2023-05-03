{ configs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  services.udev.extraRules = ''
    KERNEL=="enp*", ATTR{address}=="58:11:22:94:67:1c", NAME="lan0"
  '';
  networking.hostName = "mombox";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
  };
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];
  time.timeZone = "America/Chicago";
  networking.networkmanager = {
    enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  system.stateVersion = "22.05";
}
