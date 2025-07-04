{ nixpkgs, inputs, pkgs, lib, config, ... }:

{
  imports = [
    ../home-manager/minimal-homes.nix
    ../modules/common.nix
    ../services/common.nix
    ../services/dns-agent.nix
    ../modules/motion.nix
    ./prometheus_exporter.nix
    ./prometheus.nix
    ./blue-syncthing.nix
    ./radicale.nix
    ./baikal.nix
    ./jellyfin.nix
    ./adsb.nix
    ./veilid.nix
    ./ai-gateway.nix
  ];
  environment.systemPackages = [
  ];

  # Homeassistant

  users.users.nodered = {
    isNormalUser = true;
    uid = 2000;
    group = "nodered";
  };
  users.groups.nodered = { };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [ "/home/homeassistant/.homeassistant:/config" ];
      environment.TZ = "America/Chicago";
      image = "ghcr.io/home-assistant/home-assistant:stable";
      extraOptions = [
        "--network=host"
      ];
    };
    containers.zwavejs = {
      image = "zwavejs/zwavejs2mqtt:latest";
      volumes = [ "/home/homeassistant/zwavejs:/usr/src/app/store" ];
      extraOptions = [
        "--network=host"
        "--device=/dev/serial/by-id/usb-0658_0200-if00:/dev/zwave"
      ];
    };
    containers.nodered = {
      user = "2000";
      image = "graysonhead/nodered-homeassistant:0.2.0";
      volumes = [ "/home/nodered:/data" ];
      extraOptions = [
        "--network=host"
      ];
    };
  };

  # Plex
  services.plex = {
    enable = true;
    openFirewall = true;
    user = "plex";
    group = "users";
  };

  # Transmission
  services.transmission = {
    enable = true;
    group = "users";
    openFirewall = true;
    openRPCPort = true;
    settings = {
      rpc-bind-address = "0.0.0.0";
      download-dir = "/encrypted_storage/data/T_Downloads/new";
      incomplete-dir = "/encrypted_storage/data/T_Downloads/incomplete";
      rpc-whitelist = "10.5.5.* 127.0.0.1 localhost";
      rpc-host-whitelist = "transmission.i.graysonhead.net";
    };
  };

  systemd.services.transmission = {
    serviceConfig = {
      BindPaths = [ "/encrypted_storage/data/Media" ];
      ProtectSystem = lib.mkForce true;
    };
  };

  # Fileshares
  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  networking.firewall.allowedUDPPorts = [
    3702 # wsdd
  ];

  age.secrets.dns-acme.file = ../secrets/dns-acme.age;

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "grayson@graysonhead.net";
    };
    certs."home.graysonhead.net" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.dns-acme.path;
    };
    certs."transmission.i.graysonhead.net" = {
      dnsProvider = "digitalocean";
      credentialsFile = config.age.secrets.dns-acme.path;
    };
    certs."zwave.i.graysonhead.net" = {
      dnsProvider = "digitalocean";
      credentialsFile = config.age.secrets.dns-acme.path;
    };
    certs."nodered.i.graysonhead.net" = {
      dnsProvider = "digitalocean";
      credentialsFile = config.age.secrets.dns-acme.path;
    };
    certs."ai.graysonhead.net" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.dns-acme.path;
    };
  };

  users.groups.acme.members = [ "nginx" ];

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        workgroup = "HEADQRTRS";
        "server string" = "blue";
        "netbios name" = "blue";
        security = "user";
        "hosts allow" = [ "10.5.5." "127.0.0.1" "2603:8080:1e03:a700:b498:c38b:" "localhost" ];
        "hosts deny" = [ "0.0.0.0/0" ];
        # "guest account" = "nobody";
        # "map to guest" = "bad user";
      };
      homes = {
        comment = "Home Directories";
        browseable = "yes";
        writeable = "yes";
        "valid users" = "%S";
      };
      data = {
        path = "/encrypted_storage/data";
        browseable = "yes";
        public = "no";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      security_footage = {
        path = "/security_footage";
        browseable = "yes";
        public = "no";
        "read only" = "no";
        "guest ok" = "no";
      };
    };
  };

  # Backups
  age.secrets.restic = {
    file = ../secrets/backblaze_restic.age;
    group = "wheel";
    mode = "0440";
  };
  age.secrets.restic_password = {
    file = ../secrets/restic_password.age;
    group = "wheel";
    mode = "0440";
  };
  services.restic.backups = {
    blue_backup = {
      repository = "b2:ghead-blue-backup";
      paths = [
        "/encrypted_storage"
        "/var"
        "/etc"
      ];
      timerConfig = {
        OnCalendar = "daily";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 3"
        "--keep-monthly 6"
        "--keep-yearly 3"
      ];
      environmentFile = config.age.secrets.restic.path;
      passwordFile = config.age.secrets.restic_password.path;
      extraBackupArgs = [
        "--host=blue.i.graysonhead.net"
        "--tag=systemd.timer"
        "--verbose"
        "--exclude=/encrypted_storage/data/Media/**"
        "--exclude=/encrypted_storage/containers/**"
      ];
    };
  };

  # Reverse proxy
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."transmission.i.graysonhead.net" = {
      useACMEHost = "transmission.i.graysonhead.net";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9091";
      };
    };
    virtualHosts."zwave.i.graysonhead.net" = {
      useACMEHost = "zwave.i.graysonhead.net";
      forceSSL = true;
      extraConfig = ''
        proxy_buffering off;
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:8091";
      };
    };
    virtualHosts."nodered.i.graysonhead.net" = {
      useACMEHost = "nodered.i.graysonhead.net";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:1880";
        proxyWebsockets = true;
      };
    };
    virtualHosts."home.graysonhead.net" = {
      useACMEHost = "home.graysonhead.net";
      forceSSL = true;
      extraConfig = ''
        proxy_buffering off;
      '';
      locations."/" = {
        proxyPass = "http://[::1]:8123";
        proxyWebsockets = true;
      };
    };
    virtualHosts."motion.i.graysonhead.net" = {
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
      };
    };
    virtualHosts."ai.graysonhead.net" = {
      useACMEHost = "ai.graysonhead.net";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[::1]:8125";
      };
    };
  };

  # Firewall config
  networking.firewall.allowedTCPPorts = [
    8123
    8091
    8080
    1880
    5357 # wsdd
    80
    443
    5672 # AMQP
    15672 # Rabbitmq webui
  ];

  services.motion = {
    enable = true;
  };

  # # Rabbitmq
  # services.rabbitmq = {
  #   enable = true;
  #   plugins = [
  #     "rabbitmq_mqtt"
  #     "rabbitmq_management"
  #   ];
  # };

  # Autodiscovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
        <name replace-wildcards="yes">%h</name>
        <service>
            <type>_smb._tcp</type>
            <port>445</port>
        </service>
        </service-group>
      '';
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  # DNS Configuration
  services.dns-agent.extraConfig =
    let
      internal_interface = "enp6s0";
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
              interface = internal_interface;
            }
            {
              name = "${config.networking.hostName}";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "transmission";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "transmission";
              record_type = "A";
              interface = internal_interface;
            }
            {
              name = "zwave";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "zwave";
              record_type = "A";
              interface = internal_interface;
            }
            {
              name = "nodered";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "nodered";
              record_type = "A";
              interface = internal_interface;
            }
            {
              name = "motion";
              record_type = "A";
              interface = internal_interface;
            }
            {
              name = "factorio";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "factorio";
              record_type = "A";
              interface = "external";
            }
          ];
        }
        {
          name = "graysonhead.net";
          cloudflare_backend = {
            api_token = "$CF_API_TOKEN";
            zone_identifier = "$CF_GRAYSONHEAD_NET_ZONE_IDENTIFIER";
            zone = "graysonhead.net";
          };
          records = [
            {
              name = "factorio";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "factorio";
              record_type = "A";
              interface = "external";
            }
            {
              name = "home";
              record_type = "A";
              interface = "external";
            }
            {
              name = "ils";
              record_type = "A";
              interface = "external";
            }
            {
              name = "home";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "transmission";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "transmission";
              record_type = "A";
              interface = internal_interface;
            }
            {
              name = "calendar";
              record_type = "A";
              interface = "external";
            }
            {
              name = "calendar";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "baikal";
              record_type = "A";
              interface = "external";
            }
            {
              name = "baikal";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "vault";
              record_type = "A";
              interface = "external";
            }
            {
              name = "vault";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "photos";
              record_type = "A";
              interface = "external";
            }
            {
              name = "photos";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "ai";
              record_type = "AAAA";
              interface = internal_interface;
            }
            {
              name = "ai";
              record_type = "A";
              interface = "external";
            }
          ];
        }
      ];
    };
}
