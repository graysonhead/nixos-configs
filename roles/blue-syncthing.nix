{ nixpkgs, inputs, pkgs, config, ...}:
{
      services.syncthing = {
        enable = true;
        guiAddress = "0.0.0.0:8384";
        openDefaultPorts = true;
        user = "grayson";
        configDir = "/home/grayson/.config/syncthing";
        dataDir = "/home/grayson";
        devices = {
            "green" = { 
                id = "TZMZXLW-IQJ5FPQ-EKBQLVA-E6XMTTV-ULLRYVI-PJJFOI3-PLXHXED-FF5BPAL"; 
                autoAcceptFolders = true;
            };
            "deckchair" = {
                id = "MRE4EXS-FTYWMDQ-ALWB4ZJ-F3IKBZA-2LYO6N2-7ZJ5A6F-2ECG43E-AGOMZAY";
                autoAcceptFolders = true;
            };
        };
    };
    networking.firewall.allowedTCPPorts = [ 8384 22000];
    networking.firewall.allowedUDPPorts = [ 22000 21027];
}