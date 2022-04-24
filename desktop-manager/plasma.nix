{ config, pkgs, ...}:

{
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    services.printing.enable = true;
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
    hardware.bluetooth.enable = false;

    environment.systemPackages = with pkgs; [
        firefox
        networkmanager-iodine
        networkmanager-openvpn
        networkmanager-openconnect
        nordic
    ];
}
