{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/photoprism.nix"
  ];
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
    virtualHosts."photos.graysonhead.net" = {
      useACMEHost = "photos.graysonhead.net";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:2342";
      };
    };
  };
  services.photoprism = {
    enable = true;
    settings = {
      PHOTOPRISM_ADMIN_USER = "root";
    };
    package = pkgs.photoprism;
    address = "0.0.0.0";
    storagePath = "/encrypted_storage/data/.photos";
    originalsPath = "/encrypted_storage/data/Photos";
    port = 2342;
  };
}
