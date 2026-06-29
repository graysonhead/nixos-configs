{ config, ... }:
{
  age.secrets.dns-acme.file = ../secrets/dns-acme.age;

  security.acme = {
    acceptTerms = true;
    defaults.email = "grayson@graysonhead.net";
    certs."calibre.graysonhead.net" = {
      dnsProvider = "cloudflare";
      environmentFile = config.age.secrets.dns-acme.path;
    };
  };

  services.calibre-server = {
    enable = true;
    libraries = [ "/home/grayson/CalibreLibrary" ];
    port = 8083;
    user = "grayson";
    group = "users";
    auth = {
      enable = true;
      userDb = "/home/grayson/.config/calibre/server-users.sqlite";
    };
  };

  services.nginx.virtualHosts."calibre.graysonhead.net" = {
    useACMEHost = "calibre.graysonhead.net";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8083";
    };
  };
}
