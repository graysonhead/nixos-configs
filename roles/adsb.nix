{ nixpkgs, pkgs, config, ... }:

{
  imports = [
    ../modules/dump1090.nix
  ];

  age.secrets.fr24feed.file = ../secrets/fr24feed.age;

  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  environment.systemPackages = with pkgs; [
    dump1090-fa
  ];

  services.dump1090 = {
    enable = true;
    beast-port = 30005;
  };

  virtualisation.oci-containers = {
    containers.fr24feed = {
      image = "mikenye/fr24feed";
      environment = {
        BEASTHOST = "${config.networking.hostName}";
        BEASTPORT = "30005";
        MLAT = "yes";
      };
      environmentFiles = [
        config.age.secrets.fr24feed.path
      ];
      extraOptions = [
        "--network=host"
      ];
      ports = [ "8754:8754" ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    8754
    30005
    30003
  ];
}
