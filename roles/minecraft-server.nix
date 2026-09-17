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
      package = pkgs.fabricServers.fabric-26_1_2.override { jre_headless = pkgs.jdk25_headless; };
      openFirewall = true;
      serverProperties = {
        server-port = 25565;
        difficulty = "normal";
        gamemode = "survival";
        max-players = 20;
        motd = "Headcraft";
        white-list = true;
        online-mode = true;
      };
      whitelist = {
        darkside34 = "46839c87-d793-4ee4-9bf6-6a091b6c4650";
        ImNotSure2 = "dac225ea-5692-4566-bc22-c4c2c263c9e5";
        StuffedAnimal10 = "128047a1-eddb-4c60-9290-be8d962ab1da";
        maeroselastic = "097ae012-c512-41c1-9ce8-f704ccd638e4";
      };
      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
          FabricAPI = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/Sy2Bq7Xc/fabric-api-0.149.0%2B26.1.2.jar";
            sha512 = "c7589aa4deeaa6dbefc13247eb5e0d4e257c152ef039937f54d6ee28282d3c84ccc96483d9c3950286fed6e3dcc546709898c8a446ab143d1663bc7d49649c54";
          };
          Flan = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/Si383TIH/versions/sOppWAjh/flan-26.1.2-1.12.7-fabric.jar";
            sha512 = "80f2decccc3dc29304ef0c03e4cebde385bc9ab6e6b0beb60282b6482bdc879cfddb6bd2d2d2f5b79397354c6568b17d7d31e6e8a8bedb3a462c640953684928";
          };
          BlueMap = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/swbUV1cr/versions/bR8uae8S/bluemap-5.23-fabric.jar";
            sha512 = "7997e47e89ddf69ccea187f8b2e52a278c9d4d3e77636f06b581e7166b7549f7c900d0867a827b81eb54823d804d4d422d040788a530559f27410a539450a91e";
          };
        });
      };
      files."ops.json".value = [
        {
          uuid = "46839c87-d793-4ee4-9bf6-6a091b6c4650";
          name = "darkside34";
          level = 4;
          bypassesPlayerLimit = false;
        }
      ];
      # Accepts Mojang's EULA for BlueMap to download the Minecraft client
      # resources (textures/models) it needs to render the map.
      files."config/bluemap/core.conf" = {
        format = pkgs.formats.yaml { };
        value.accept-download = true;
      };
    };
  };
}
