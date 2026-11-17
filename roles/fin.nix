{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.fin.nixosModules.default
  ];

  # The MariaDB server itself (package, dataDir on /encrypted_storage) is
  # configured in photoprism.nix.
  services.mysql = {
    enable = true;
    ensureDatabases = [ "fin" ];
    ensureUsers = [{
      name = "fin";
      ensurePermissions = {
        "fin.*" = "ALL PRIVILEGES";
      };
    }];
  };

  # SIMPLEFIN_ACCESS_URL=... and optionally FIN_API_TOKEN_HASH=...
  age.secrets.fin-environment = {
    file = ../secrets/fin-environment.age;
    owner = "fin";
    group = "fin";
  };

  services.fin = {
    enable = true;
    package = inputs.fin.packages.x86_64-linux.fin;
    # unix_socket authentication: the service runs as the `fin` user
    databaseUrl = "mysql://fin@localhost/fin?socket=/run/mysqld/mysqld.sock";
    timezone = "America/Chicago";
    environmentFiles = [ config.age.secrets.fin-environment.path ];
  };

  # For `fin user add`, `fin token new`, `fin import calendarbudget`
  environment.systemPackages = [ config.services.fin.package ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."fin.graysonhead.net" = {
      useACMEHost = "fin.graysonhead.net";
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:4334";
    };
  };
}
