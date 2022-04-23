{ config, pkgs, ...}:

{
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    services.printing.enable = true;
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    environment.systemPackages = with pkgs; [
        firefox
        networkmanager-iodine
        networkmanager-openvpn
        networkmanager-openconnect
    ];
}