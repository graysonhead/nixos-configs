{ nixpkgs, inputs, pkgs, config, ... }:
{
    age.secrets.dns-acme.file = ../secrets/dns-acme.age;
    services.radicale = {
        enable = true;
        settings = {
            server.hosts = [ "0.0.0.0:5232" ];
            auth = {
                type = "htpasswd";
                htpasswd_filename = "/encrypted_storage/radicale/.htpasswd";
                htpasswd_encryption = "plain";
            };
        };
    };
    networking.firewall.allowedTCPPorts = [
        5232
    ];
    security.acme.certs."calendar.graysonhead.net" = {
        dnsProvider = "cloudflare";
        credentialsFile = config.age.secrets.dns-acme.path;
    };
    services.nginx.virtualHosts."calendar.graysonhead.net" = {
        useACMEHost = "calendar.graysonhead.net";
        forceSSL = true;
        locations."/" = {
            proxyPass = "http://127.0.0.1:5232";
        };
    };
}