{ nixpkgs, inputs, pkgs, config, ... }:
{
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    openDefaultPorts = true;
    user = "grayson";
    configDir = "/home/grayson/.config/syncthing";
    dataDir = "/home/grayson";
  };
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
