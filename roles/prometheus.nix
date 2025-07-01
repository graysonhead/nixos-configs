{ config, lib, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    3000
    9190
    9192
  ];
  services.prometheus = {
    enable = true;
    port = 9190;
    pushgateway = {
      enable = true;
      web.listen-address = ":9192";
    };
    scrapeConfigs = [
      {
        job_name = "prometheus";
        honor_labels = true;
        static_configs = [
          {
            targets = [
              "localhost:9100"
              "localhost:9190"
            ];
          }
        ];
      }
    ];
  };
}
