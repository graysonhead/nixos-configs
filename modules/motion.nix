{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.services.motion;
in
{
  options = {
    services.motion = {
      enable = mkEnableOption "motion";

      package = mkOption {
        default = pkgs.motion;
        defaultText = literalExpression "pkgs.motion";
        type = types.package;
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf config.services.motion.enable {
    systemd.services.motion = {
      description = "motion";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "local-fs.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/motion -c /etc/motion/motion.conf";
      };
    };
    networking.firewall.allowedTCPPorts = if cfg.openFirewall then [ 8080 8081 ] else [ ];
  };
}
