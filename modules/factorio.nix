{ config, lib, pkgs, ... }:

# This is pretty much a straight up copy of the official factorio server module, but with modifications to allow agenix secrets

with lib;

let
  cfg = config.services.gfactorio;
  name = "Factorio";
  stateDir = "/var/lib/${cfg.stateDirName}";
  mkSavePath = name: "${stateDir}/saves/${name}.zip";
  configFile = pkgs.writeText "factorio.conf" ''
    use-system-read-write-data-directories=true
    [path]
    read-data=${cfg.package}/share/factorio/data
    write-data=${stateDir}
  '';
  serverSettings = {
    name = cfg.game-name;
    description = cfg.description;
    visibility = {
      public = cfg.public;
      lan = cfg.lan;
    };
    username = cfg.username;
    password = cfg.password;
    token = cfg.token;
    game_password = cfg.game-password;
    require_user_verification = cfg.requireUserVerification;
    max_upload_in_kilobytes_per_second = 0;
    minimum_latency_in_ticks = 0;
    ignore_player_limit_for_returning_players = false;
    allow_commands = "admins-only";
    autosave_interval = cfg.autosave-interval;
    autosave_slots = 5;
    afk_autokick_interval = 0;
    auto_pause = true;
    only_admins_can_pause_the_game = true;
    autosave_only_on_server = true;
    non_blocking_saving = cfg.nonBlockingSaving;
  } // cfg.extraSettings;
  serverSettingsFile = pkgs.writeText "server-settings.json" (builtins.toJSON (filterAttrsRecursive (n: v: v != null) serverSettings));
  serverAdminsFile = pkgs.writeText "server-adminlist.json" (builtins.toJSON cfg.admins);
  modDir = pkgs.factorio-utils.mkModDirDrv cfg.mods;
in
{
  options = {
    services.gfactorio = {
      enable = mkEnableOption name;
      port = mkOption {
        type = types.int;
        default = 34197;
        description = ''
          The port to which the service should bind.
        '';
      };

      bind = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          The address to which the service should bind.
        '';
      };

      admins = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "username" ];
        description = ''
          List of player names which will be admin.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to automatically open the specified UDP port in the firewall.
        '';
      };
      saveName = mkOption {
        type = types.str;
        default = "default";
        description = ''
          The name of the savegame that will be used by the server.

          When not present in /var/lib/''${config.services.factorio.stateDirName}/saves,
          a new map with default settings will be generated before starting the service.
        '';
      };
      loadLatestSave = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Load the latest savegame on startup. This overrides saveName, in that the latest
          save will always be used even if a saved game of the given name exists. It still
          controls the 'canonical' name of the savegame.

          Set this to true to have the server automatically reload a recent autosave after
          a crash or desync.
        '';
      };
      environmentFiles = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = [ "/run/keys/factorio.env" ];
        description = ''
          File to load as environment file. Environment variables from this file
          will be interpolated into the config file using envsubst with this
          syntax: <literal>$ENVIRONMENT</literal> or <literal>''${VARIABLE}</literal>.
          This is useful to avoid putting secrets into the nix store.
        '';
      };
      # TODO Add more individual settings as nixos-options?
      # TODO XXX The server tries to copy a newly created config file over the old one
      #   on shutdown, but fails, because it's in the nix store. When is this needed?
      #   Can an admin set options in-game and expect to have them persisted?
      configFile = mkOption {
        type = types.path;
        default = configFile;
        defaultText = literalExpression "configFile";
        description = ''
          The server's configuration file.

          The default file generated by this module contains lines essential to
          the server's operation. Use its contents as a basis for any
          customizations.
        '';
      };
      stateDirName = mkOption {
        type = types.str;
        default = "factorio";
        description = ''
          Name of the directory under /var/lib holding the server's data.

          The configuration and map will be stored here.
        '';
      };
      mods = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = ''
          Mods the server should install and activate.

          The derivations in this list must "build" the mod by simply copying
          the .zip, named correctly, into the output directory. Eventually,
          there will be a way to pull in the most up-to-date list of
          derivations via nixos-channel. Until then, this is for experts only.
        '';
      };
      game-name = mkOption {
        type = types.nullOr types.str;
        default = "Factorio Game";
        description = ''
          Name of the game as it will appear in the game listing.
        '';
      };
      description = mkOption {
        type = types.nullOr types.str;
        default = "";
        description = ''
          Description of the game that will appear in the listing.
        '';
      };
      extraSettings = mkOption {
        type = types.attrs;
        default = { };
        example = { admins = [ "username" ]; };
        description = ''
          Extra game configuration that will go into server-settings.json
        '';
      };
      public = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Game will be published on the official Factorio matching server.
        '';
      };
      lan = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Game will be broadcast on LAN.
        '';
      };
      username = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Your factorio.com login credentials. Required for games with visibility public.
        '';
      };
      package = mkOption {
        type = types.package;
        default = pkgs.factorio-headless;
        defaultText = literalExpression "pkgs.factorio-headless";
        example = literalExpression "pkgs.factorio-headless-experimental";
        description = ''
          Factorio version to use. This defaults to the stable channel.
        '';
      };
      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Your factorio.com login credentials. Required for games with visibility public.
        '';
      };
      token = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Authentication token. May be used instead of 'password' above.
        '';
      };
      game-password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Game password.
        '';
      };
      requireUserVerification = mkOption {
        type = types.bool;
        default = true;
        description = ''
          When set to true, the server will only allow clients that have a valid factorio.com account.
        '';
      };
      autosave-interval = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 10;
        description = ''
          Autosave interval in minutes.
        '';
      };
      nonBlockingSaving = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Highly experimental feature, enable only at your own risk of losing your saves.
          On UNIX systems, server will fork itself to create an autosave.
          Autosaving on connected Windows clients will be disabled regardless of autosave_only_on_server option.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.factorio =
      let
        finalConfigFile =
          if config.services.gfactorio.environmentFiles == [ ]
          then serverSettingsFile
          else "/var/run/factorio/server-settings.json";
      in
      {
        description = "Factorio headless server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        preStart = toString [
          "test -e ${stateDir}/saves/${cfg.saveName}.zip"
          "||"
          "${cfg.package}/bin/factorio"
          "--config=${finalConfigFile}"
          "--create=${mkSavePath cfg.saveName}"
          (optionalString (cfg.mods != [ ]) "--mod-directory=${modDir}")
        ];

        serviceConfig = {
          Restart = "always";
          KillSignal = "SIGINT";
          DynamicUser = true;
          StateDirectory = cfg.stateDirName;
          UMask = "0007";
          EnvironmentFile = config.services.gfactorio.environmentFiles;
          RuntimeDirectory = "factorio";
          ExecStartPre = lib.optional (config.services.gfactorio.environmentFiles != [ ])
            (pkgs.writeShellScript "pre-start" ''
              umask 077
              ${pkgs.envsubst}/bin/envsubst -i "${serverSettingsFile}" > /var/run/factorio/server-settings.json
            '');
          ExecStart = toString [
            "${cfg.package}/bin/factorio"
            "--config=${cfg.configFile}"
            "--port=${toString cfg.port}"
            "--bind=${cfg.bind}"
            (optionalString (!cfg.loadLatestSave) "--start-server=${mkSavePath cfg.saveName}")
            "--server-settings=${finalConfigFile}"
            (optionalString cfg.loadLatestSave "--start-server-load-latest")
            (optionalString (cfg.mods != [ ]) "--mod-directory=${modDir}")
            (optionalString (cfg.admins != [ ]) "--server-adminlist=${serverAdminsFile}")
          ];

          # Sandboxing
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
          RestrictRealtime = true;
          RestrictNamespaces = true;
          MemoryDenyWriteExecute = true;
        };
      };

    networking.firewall.allowedUDPPorts = if cfg.openFirewall then [ cfg.port ] else [ ];
  };
}
