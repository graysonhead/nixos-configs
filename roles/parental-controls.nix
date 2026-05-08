{ inputs, ... }:
{
  imports = [
    inputs.parental-controls.nixosModules.parental-controls-server
  ];

  services.parental-controls = {
    enable = true;
    host = "0.0.0.0";
    port = 8000;
  };

  networking.firewall.allowedTCPPorts = [ 8000 ];
}
