{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.services.dump1090;
in
{
  options = {
    services.dump1090 = {
      enable = mkEnableOption "dump1090";

      package = mkOption {
        default = pkgs.dump1090-fa;
        defaultText = literalExpression "pkgs.dump1090-fa";
        type = types.package;
      };

      beast-port = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 30005;
        description = ''beast port'';
      };
    };
  };

  config = mkIf config.services.dump1090.enable {
    systemd.services.dump1090 = {
      description = "dump1090";
      serviceConfig = {
        Restart = "always";
        Type = "simple";
        ExecStart = toString [
          "${cfg.package}/bin/dump1090"
          "--net"
          "--net-heartbeat"
          "--quiet"
          (optionalString (cfg.beast-port != null) "--net-bo-port ${toString cfg.beast-port}")
        ];
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
    };
  };
}
