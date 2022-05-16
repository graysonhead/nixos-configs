{ config, nixpkgs, lib, dns-agent, ... }:

{
    services.dns-agent.enable = true;
    age.secrets.digitalocean-key.file = ../secrets/digitalocean-key.age;
    services.dns-agent.environmentFiles = [config.age.secrets.digitalocean-key.path];
    services.dns-agent.extraConfig = let
        interface_name_list = builtins.attrNames config.networking.interfaces;
        first_interface = builtins.elemAt interface_name_list 0;
    in {
        settings.external_ipv4_check_url = "https://api.ipify.org/?format=text";
        domains = [
            {
                name = "i.graysonhead.net";
                digital_ocean_backend.api_key = "$DO_API_KEY";
                records = [
                    {
                        name = "${config.networking.hostName}";
                        record_type = "A";
                        interface = "${first_interface}";
                    }
                    {
                        name = "${config.networking.hostName}";
                        record_type = "AAAA";
                        interface = "${first_interface}";
                    }
                ];
            }
        ];
    };
}