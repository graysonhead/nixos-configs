{ config, lib, pkgs, inputs, ...}:

with lib;

let
    cfg = config.services.factorio-bot;
in
{
    options = {
        services.factorio-bot = {
            enable = mkEnableOption "factorio-bot";

            package = mkOption {
                default = inputs.factorio-bot.defaultPackage.${pkgs.system};
                defaultText = literalExpression "inputs.factorio-bot.defaultPackage";
                type = types.package;
            };

            environmentFile = mkOption {
                type = types.path;
                default = /run/agenix/factorio-bot;
            };

        };
    };

    config = mkIf config.services.factorio-bot.enable {
        systemd.services.factorio-bot = {
            description = "factorio-bot";
            serviceConfig = {
                Restart = "always";
                EnvironmentFile = config.services.factorio-bot.environmentFile;
                Type = "simple";
                ExecStart = "${cfg.package}/bin/factoriobot";
            };
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" "factorio.service" ];
        };
    };
}