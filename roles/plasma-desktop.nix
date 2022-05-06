{ nixpkgs, pkgs, home-manager, ... }:

{
    imports = [
        ../home-manager/full-homes.nix
        ../modules/common.nix
        ../services/syncthing.nix
        ../home-manager/full-homes.nix
    ];
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    services.printing.enable = true;
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
    hardware.bluetooth.enable = true;
    programs.kdeconnect.enable = true;
    environment.systemPackages = with pkgs; [
        firefox
        networkmanager-iodine
        networkmanager-openvpn
        networkmanager-openconnect
        nordic
        slack
        discord
        teamspeak_client
        zoom-us
    ];
}