{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];
  time.timeZone = "America/Chicago";
  networking.hostName = "green";
  networking.networkmanager = {
    enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  system.stateVersion = "22.05";
}
