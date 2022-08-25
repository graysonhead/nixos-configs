{ config }:
{
    networking.firewall.allowedTCPPorts = [
        3000
        9090
        9093
    ];
    services.promethus = {
        enable = true;
        pushgateway = {
            enable = true;
        };
        scrapeConfigs = [
            {
                job_name = "local";
                honor_labels = true;
                static_configss = [
                    {
                        targets = ["localhost:9091" ];
                    }
                ];
            }
        ];
    };
}