{ config, lib, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 9100 ];
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [
        "systemd"
      ];
    };
    systemd.enable = true;
    process.enable = true;
  };
}
