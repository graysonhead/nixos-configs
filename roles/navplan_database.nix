{ nixpkgs, inputs, pkgs, lib, config, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "/encrypted_storage/data/postgres";

    # Enable PostGIS extension
    extensions = ps: with ps; [ postgis ];

    # Authentication: peer for local, scram-sha-256 for network
    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     peer
      host    all             all             127.0.0.1/32            scram-sha-256
      host    all             all             ::1/128                 scram-sha-256
      host    all             all             10.5.5.0/24             scram-sha-256
    '';

    # PostgreSQL configuration
    settings = {
      max_connections = 100;
      shared_buffers = "256MB";
      effective_cache_size = "1GB";
      maintenance_work_mem = "64MB";

      # Logging
      logging_collector = true;
      log_directory = "log";
      log_filename = "postgresql-%Y-%m-%d_%H%M%S.log";
      log_statement = "mod";
    };

    # Create navplan database and user
    ensureDatabases = [ "navplan" ];
    ensureUsers = [{
      name = "navplan";
      ensureDBOwnership = true;
    }];
  };

  # The navplan user and group are created by the service modules
  # (webserver.nix and pipeline-runner.nix), so we don't need to create them here

  # Password for the navplan role, used for scram-sha-256 network auth by
  # any machine temporarily running roles/navplan-worker.nix. Local peer
  # auth (used by blue's own webserver/pipeline-runner) doesn't need this.
  age.secrets.navplan-db-password = {
    file = ../secrets/navplan-db-password.age;
    mode = "0440";
    owner = "postgres";
  };

  systemd.services.navplan-set-db-password = {
    description = "Set navplan postgres role password from agenix secret";
    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "postgres";
    };
    script = ''
      ${config.services.postgresql.package}/bin/psql -c \
        "ALTER ROLE navplan WITH PASSWORD '$(cat ${config.age.secrets.navplan-db-password.path})'"
    '';
  };

  # Open PostgreSQL port on firewall
  networking.firewall.allowedTCPPorts = [ 5432 ];
}
