{ nixpkgs, pkgs, config, ... }:

{
  services.open-webui = {
    enable = true;
    port = 8125;
  };
}
