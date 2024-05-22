{ nixpkgs, inputs, lib, config, ... }:

{
  imports = [
  ];

  age.secrets.vaultwarden = {
    file = ../secrets/vaultwarden.age;
  };
  age.secrets.dns-acme.file = ../secrets/dns-acme.age;

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "grayson@graysonhead.net";
    };
    certs."vault.graysonhead.net" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.dns-acme.path;
    };
  };

  services.nginx = {
    virtualHosts."vault.graysonhead.net" = {
      useACMEHost = "vault.graysonhead.net";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8222";
      };
    };
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    backupDir = "/encrypted_storage/data/vw_backups";
    environmentFile = config.age.secrets.vaultwarden.path;
    config = {
      DOMAIN = "https://vault.graysonhead.net";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
    };
  };
}
