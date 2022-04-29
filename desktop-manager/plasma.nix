# Sets up a system with a full Plasma UI and enables
# common desktop/laptop services
{ config, pkgs, ...}:

{
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
    ];
}
