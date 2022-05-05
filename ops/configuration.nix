{ config, pkgs, ... }:

{
    imports =
        [
            ./hardware-configuration.nix
        ];
    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;
    boot.loader.grub.device = "/dev/vda";
    networking.hostName = "ops";
    networking.search = ["i.graysonhead.net"];
    time.timeZone = "America/Chicago";
    networking.useDHCP = false;
    networking.interfaces.enp1s0.useDHCP = true;
    system.stateVersion = "21.11";
}