{ config, pkgs, lib, inputs, navplan, ... }:
{
  imports = [
    navplan.nixosModules.x86_64-linux.default
  ];

  services.navplan.webserver = {
    enable = true;
    package = navplan.packages.x86_64-linux.navplan;

    # Network configuration
    host = "127.0.0.1"; # Bind to localhost, use nginx for external access
    port = 4333;
    openFirewall = false; # Will use nginx reverse proxy

    # Database configuration (peer authentication via Unix socket)
    databaseUrl = "postgresql:///navplan?host=/run/postgresql";
  };

  services.navplan.pipeline-runner = {
    enable = true; # Disabled until data files are populated
    package = navplan.packages.x86_64-linux.navplan;

    # Data paths (will be populated later)
    demDirectory = "/encrypted_storage/data/navplan/dems";
    nlcdRaster = "/encrypted_storage/data/navplan/nlcd/nlcd.tif";

    # Database configuration (peer authentication via Unix socket)
    databaseUrl = "postgresql://localhost/navplan?host=/run/postgresql";

    # Pipeline parameters
    maxSlope = 8.0; # Maximum slope percentage for landable areas

    # Run mode: use worker for continuous processing
    runMode = "worker"; # Options: "worker", "populate-only", "stats"
    singleRun = false; # Set to true for one-time processing
    logLevel = "debug";

    # Systemd timer for periodic execution (optional)
    timer = {
      enable = false; # Disabled initially, enable later if needed
      calendar = "daily"; # Run daily
    };
  };

  # Nginx configuration for internal access
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;

    virtualHosts."navplan-staging.graysonhead.net" = {
      useACMEHost = "navplan-staging.graysonhead.net";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4333";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };

    virtualHosts."navplan.i.graysonhead.net" = {
      useACMEHost = "navplan.i.graysonhead.net";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4333";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };

  # Open HTTP and HTTPS ports for nginx
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
