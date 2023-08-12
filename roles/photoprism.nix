{ inputs, pkgs, lib, config, ... }:
{
  age.secrets.photoprism_admin = {
    file = ../secrets/photoprism_admin_password.age;
  };
  age.secrets.dns-acme.file = ../secrets/dns-acme.age;
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "grayson@graysonhead.net";
    };
    certs."photos.graysonhead.net" = {
      dnsProvider = "digitalocean";
      credentialsFile = config.age.secrets.dns-acme.path;
    };
  };
  services.nginx = {
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "500m";
    virtualHosts."photos.graysonhead.net" = {
      useACMEHost = "photos.graysonhead.net";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:2342";
        proxyWebsockets = true;
        # extraConfig = ''
        #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #   proxy_set_header Host $host;
        #   proxy_buffering off;
        # '';
      };
    };
  };
  services.photoprism = {
    enable = true;
    settings = {
      PHOTOPRISM_ADMIN_USER = "root";
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = "photoprism";
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      PHOTOPRISM_DATABASE_USER = "photoprism";
      PHOTOPRISM_SITE_URL = "https://photos.graysonhead.net";
      PHOTOPRISM_SITE_TITLE = "Photoprism";
    };
    passwordFile = config.age.secrets.photoprism_admin.path;
    package = pkgs.photoprism;
    address = "0.0.0.0";
    port = 2342;
    originalsPath = "/var/lib/private/photoprism/originals";
    storagePath = "/var/lib/private/photoprism";
  };

  services.mysql = {
    enable = true;
    dataDir = "/encrypted_storage/data/mysql";
    package = pkgs.mariadb;
    ensureDatabases = [ "photoprism" ];
    ensureUsers = [{
      name = "photoprism";
      ensurePermissions = {
        "photoprism.*" = "ALL PRIVILEGES";
      };
    }];
  };
}
