{ nixpkgs, pkgs, config, ... }:

{
  services.ollama = {
    enable = true;
  };
  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 8125;
    openFirewall = true;
  };
}
