{ nixpkgs, inputs, pkgs, config, ... }:
{
  # Enable Baikal service
  services.baikal = {
    enable = true;
    virtualHost = "baikal.graysonhead.net";
  };

  # Configure SSL certificate
  age.secrets.dns-acme.file = ../secrets/dns-acme.age;
  security.acme.certs."baikal.graysonhead.net" = {
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets.dns-acme.path;
  };

  # Configure nginx reverse proxy
  services.nginx.virtualHosts."baikal.graysonhead.net" = {
    useACMEHost = "baikal.graysonhead.net";
    forceSSL = true;
  };
}
