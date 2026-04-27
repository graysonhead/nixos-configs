{ nixpkgs, pkgs, inputs, lib, config, ... }:

{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlays.default ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers.fabric = {
      enable = true;
      package = pkgs.fabricServers.fabric.override { jre_headless = pkgs.jdk25_headless; };
      openFirewall = true;
      serverProperties = {
        server-port = 25565;
        difficulty = "normal";
        gamemode = "survival";
        max-players = 20;
        motd = "graysonhead.net Minecraft";
        white-list = false;
        online-mode = true;
      };
    };
  };
}
