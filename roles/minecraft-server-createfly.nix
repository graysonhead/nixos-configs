{ nixpkgs, pkgs, inputs, lib, config, ... }:

{
  services.minecraft-servers.servers.createfly = {
    enable = true;
    package = pkgs.fabricServers.fabric-26_2.override { jre_headless = pkgs.jdk25_headless; };
    openFirewall = true;
    serverProperties = {
      server-port = 25566;
      difficulty = "normal";
      gamemode = "survival";
      max-players = 20;
      motd = "Create: Fly";
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
        CreateFly = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/dKvj0eNn/versions/phlsMPgT/create-fly-26.2-rc-2-6.0.9-1-server.jar";
          sha512 = "9cdd10ed6484f26ad9ef5ddc1a86217a4344f09d30190023c57b63d7d6742614392db5373253eff95b4858a423078c8f377b96d28e53a3dfe12485cac0c30ca6";
        };
        BlueMap = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/swbUV1cr/versions/xvccCRD9/bluemap-5.24-fabric.jar";
          sha512 = "cb81b5382b58837b8dfb92f97e9234ea15b1a4125ec8b57913f06f9d0baf29f0091c2b9dbd189c97aa75ae4832c5acc4c670fb4afbaa67b0ea8b7e9c0f7bbe13";
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
    files."config/bluemap/webserver.conf" = {
      format = pkgs.formats.yaml { };
      value.port = 8101;
    };
  };
}
