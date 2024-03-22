{ config, nixpkgs, lib, inputs, ... }:

{
  imports = [
  ];
  services.dns-agent.enable = true;
  age.secrets.digitalocean-key.file = ../secrets/digitalocean-key.age;
  age.secrets.cloudflare-dns.file = ../secrets/cloudflare-dns.age;
  services.dns-agent.environmentFiles = [ config.age.secrets.digitalocean-key.path config.age.secrets.cloudflare-dns.path ];
}
