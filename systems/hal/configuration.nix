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

  system.stateVersion = "23.11";
}
