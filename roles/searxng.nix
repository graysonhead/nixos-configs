{ inputs, pkgs, lib, config, ... }:
{
  age.secrets.dns-acme.file = ../secrets/dns-acme.age;

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "grayson@graysonhead.net";
    };
    certs."search.graysonhead.net" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.dns-acme.path;
    };
  };

  services.nginx = {
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts."search.graysonhead.net" = {
      useACMEHost = "search.graysonhead.net";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8888";
        proxyWebsockets = true;
      };
    };
  };

  services.searx = {
    enable = true;
    settings = {
      server = {
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = "@SEARX_SECRET_KEY@";
        base_url = "https://search.graysonhead.net";
        limiter = false;
        public_instance = false;
      };
      ui = {
        static_use_hash = true;
      };
      search = {
        safe_search = 0;
        autocomplete = "duckduckgo";
        default_lang = "en-US";
        formats = [ "html" "json" ];
      };
    };
    environmentFile = "/run/secrets/searxng-environment";
  };

  age.secrets.searxng-environment = {
    file = ../secrets/searxng-environment.age;
    path = "/run/secrets/searxng-environment";
  };
}
