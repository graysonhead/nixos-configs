{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hal";
  networking.networkmanager = {
    enable = true;
  };

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # NVIDIA GPU support for compute workloads
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = false;
  };

  services.xserver.screenSection = ''
    Option "ConnectedMonitor" "DFP"
  '';

  # Set permissions for /games directory to be accessible by users group
  systemd.tmpfiles.rules = [
    "d /games 0775 root users - -"
  ];

  system.stateVersion = "23.11";
}
