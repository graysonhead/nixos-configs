{ inputs, config, ... }:
{
  imports = [
    inputs.parental-controls.nixosModules.parental-controls-server
  ];

  services.parental-controls = {
    enable = true;
    host = "127.0.0.1";
    port = 8000;
  };

  security.acme.certs."parental-controls.graysonhead.net" = {
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets.dns-acme.path;
  };

  services.nginx.virtualHosts."parental-controls.graysonhead.net" = {
    useACMEHost = "parental-controls.graysonhead.net";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8000";
    };
  };
}
