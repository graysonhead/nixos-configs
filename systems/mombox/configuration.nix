{ configs, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];
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
    system.stateVersion = "22.05";
}