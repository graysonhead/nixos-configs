{ nixpkgs, pkgs, config, ... }:

{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 8125;
    openFirewall = true;
  };

  # Age secret for DNS ACME
  age.secrets.dns-acme.file = ../secrets/dns-acme.age;

  # # SSL certificates with Let's Encrypt
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "grayson@graysonhead.net";
  #   certs."hal.i.graysonhead.net" = {
  #     dnsProvider = "digitalocean";
  #     credentialsFile = config.age.secrets.dns-acme.path;
  #   };
  # };

  # # Nginx reverse proxy with SSL termination
  # services.nginx = {
  #   enable = true;
  #   recommendedGzipSettings = true;
  #   recommendedOptimisation = true;
  #   recommendedProxySettings = true;
  #   recommendedTlsSettings = true;

  #   virtualHosts."hal.i.graysonhead.net" = {
  #     useACMEHost = "hal.i.graysonhead.net";
  #     forceSSL = true;
  #     locations."/" = {
  #       proxyPass = "http://127.0.0.1:8125";
  #       proxyWebsockets = true;
  #       extraConfig = ''
  #         proxy_set_header Host 127.0.0.1:8125;
  #         proxy_set_header X-Real-IP $remote_addr;
  #         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  #         proxy_set_header X-Forwarded-Proto $scheme;
  #         proxy_buffering off;
  #         proxy_request_buffering off;
  #         proxy_set_header Upgrade $http_upgrade;
  #         proxy_set_header Connection "upgrade";
  #       '';
  #     };
  #   };
  # };

  # # Add nginx to acme group for certificate access
  # users.groups.acme.members = [ "nginx" ];

  # # Open firewall ports for HTTP/HTTPS
  # networking.firewall = {
  #   allowedTCPPorts = [ 80 443 ];
  # };
}
