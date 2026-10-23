# Temporary navplan DEM pipeline worker for any machine on the LAN.
#
# Points a navplan-pipeline-runner at blue's postgres over the network
# (10.5.5.0/24, already permitted by roles/navplan_database.nix's pg_hba
# rules) instead of the local peer-authenticated socket. Intended to be
# applied ad-hoc to spare machines to help burn down the dem_import_queue,
# then removed again (see roles/navplan.nix for blue's permanent setup).
#
# Expects DEM tiles and the NLCD raster to already be copied to this host
# (see demDirectory/nlcdRaster below) rather than read over the network,
# since the DEM set is small (~235M) and this avoids pipeline I/O going
# over the LAN for every tile read.
{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.navplan.nixosModules.x86_64-linux.default
  ];

  age.secrets.navplan-db-password = {
    file = ../secrets/navplan-db-password.age;
    mode = "0440";
  };

  services.navplan.pipeline-runner = {
    enable = true;
    package = inputs.navplan.packages.${pkgs.system}.navplan;

    demDirectory = "/var/lib/navplan-worker/dems";
    nlcdRaster = "/var/lib/navplan-worker/nlcd.tif";

    # Placeholder: the real connection string (with password) is supplied
    # at runtime via DATABASE_URL below, which clap's `env = "DATABASE_URL"`
    # on --database-url only honors when --database-url isn't also passed
    # on the command line. We override ExecStart below to drop that flag
    # so the real secret never lands in the Nix store.
    databaseUrl = "postgresql://navplan@10.5.5.5:5432/navplan";

    runMode = "worker";
    logLevel = "info";
  };

  # Override the module's ExecStart to omit --database-url (which would
  # otherwise bake the literal cfg.databaseUrl, password included, into
  # the world-readable Nix store) and instead rely on the DATABASE_URL
  # environment variable, read at service start from the agenix secret.
  systemd.services.navplan-pipeline-runner.serviceConfig = {
    EnvironmentFile = lib.mkForce [ ];
    ExecStart = lib.mkForce (
      let
        cfg = config.services.navplan.pipeline-runner;
      in
      pkgs.writeShellScript "navplan-worker-start" ''
        set -euo pipefail
        export DATABASE_URL="postgresql://navplan:$(cat ${config.age.secrets.navplan-db-password.path})@10.5.5.5:5432/navplan"
        exec ${cfg.package}/bin/pipeline-runner \
          --log-level ${cfg.logLevel} \
          process-dem-directory \
          --dem-directory ${lib.escapeShellArg (toString cfg.demDirectory)} \
          --nlcd ${lib.escapeShellArg (toString cfg.nlcdRaster)} \
          --max-slope ${toString cfg.maxSlope} \
          --sieve-size ${toString cfg.sieveSize} \
          --simplify-tolerance ${toString cfg.simplifyTolerance} \
          --max-retries ${toString cfg.maxRetries} \
          --stale-timeout-minutes ${toString cfg.staleTimeoutMinutes} \
          --extensions ${lib.escapeShellArg cfg.fileExtensions}
      ''
    );
  };
}
