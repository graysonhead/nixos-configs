{ config, nixpkgs, lib, inputs, ... }:

{
  imports = [
  ];
  services.dns-agent.enable = true;
  age.secrets.digitalocean-key.file = ../secrets/digitalocean-key.age;
  services.dns-agent.environmentFiles = [ config.age.secrets.digitalocean-key.path ];
}
