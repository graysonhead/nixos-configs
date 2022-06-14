{ nixpkgs, inputs, lib, config, ... }:

{
  imports = [
    ../home-manager/minimal-homes.nix
    ../modules/common.nix
    ../modules/factorio.nix
    ../modules/factorio-bot.nix
    ../modules/home-backups.nix
    ../services/common.nix
    ../services/dns-agent.nix
  ];
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  age.secrets.factorio.file = ../secrets/factorio.age;
  age.secrets.factorio-bot.file = ../secrets/factorio-bot.age;
  networking.firewall.allowedTCPPorts = [ 25575 ];
  # Factorio server
  services.gfactorio = {
    enable = true;
    token = "$TOKEN";
    openFirewall = true;
    admins = [ "darkside34" ];
    description = "Welcome to the darkside, we have cookies";
    game-password = "$GAME_PASSWORD";
    game-name = "The Darkside";
    saveName = "save";
    environmentFiles = [ config.age.secrets.factorio.path ];
    rConBind = "0.0.0.0:25575";
    rConPassword = "$GAME_PASSWORD";
  };
  # Factorio bot
  services.factorio-bot = {
    enable = true;
    environmentFile = config.age.secrets.factorio-bot.path;
  };

  services.restic.backups = {
    factorio = {
      repository = "b2:nixos-backups";
      paths = [
        "/var/lib/factorio"
        "/var/lib/private"
      ];
      timerConfig = {
        OnCalendar = "daily";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 75"
      ];
      environmentFile = config.age.secrets.restic.path;
      passwordFile = config.age.secrets.restic_password.path;
    };
  };

  services.dns-agent.extraConfig =
    let
      interface_name_list = builtins.attrNames config.networking.interfaces;
      first_interface = builtins.elemAt interface_name_list 0;
    in
    {
      settings.external_ipv4_check_url = "https://api.ipify.org/?format=text";
      domains = [
        {
          name = "i.graysonhead.net";
          digital_ocean_backend.api_key = "$DO_API_KEY";
          records = [
            {
              name = "${config.networking.hostName}";
              record_type = "A";
              interface = "${first_interface}";
            }
            {
              name = "${config.networking.hostName}";
              record_type = "AAAA";
              interface = "${first_interface}";
            }
          ];
        }
        {
          name = "graysonhead.net";
          digital_ocean_backend.api_key = "$DO_API_KEY";
          records = [
            {
              name = "${config.networking.hostName}";
              record_type = "A";
              interface = "external";
            }
            {
              name = "${config.networking.hostName}";
              record_type = "AAAA";
              interface = "${first_interface}";
            }
          ];
        }
      ];
    };
}
