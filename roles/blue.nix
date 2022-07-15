{ nixpkgs, inputs, config, ... }:

{
    imports = [
        ../home-manager/minimal-homes.nix
        ../modules/common.nix
        ../services/common.nix
        ../services/dns-agent.nix
    ];
    services.openssh.enable = true;
    security.sudo.wheelNeedsPassword = false;
    environment.systemPackages = [
    ];

    

    # Homeassistant

    users.users.nodered = {
        isNormalUser = true;
        uid = 2000;
        group = "nodered";
    };

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
            image = "graysonhead/nodered-homeassistant:0.1.0";
            volumes = [ "/home/nodered:/data" ];
            extraOptions = [
                "--network=host"
            ];
        };
    };
    networking.firewall.allowedTCPPorts = [ 
        8123 
        8091 
        1880 
        5357 # wsdd
        80
        443
    ];

    # Plex
    services.plex = {
        enable = true;
        openFirewall = true;
        user = "plex";
        group = "plex";
    };

    # Transmission
    services.transmission = {
        enable = true;
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

    # Fileshares
    services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
    networking.firewall.allowedUDPPorts = [
        3702 # wsdd
    ];

    services.samba = {
        enable = true;
        securityType = "user";
        openFirewall = true;
        extraConfig = ''
            workgroup = HEADQRTRS
            server string = blue
            netbios name = blue
            security = user 
            #use sendfile = yes
            #max protocol = smb2
            # note: localhost is the ipv6 localhost ::1
            hosts allow = 10.5.5. 127.0.0.1 2603:8080:1e03:a700:b498:c38b: localhost
            hosts deny = 0.0.0.0/0
            guest account = nobody
            map to guest = bad user

            [homes]
            comment = Home Directories
            browseable = yes
            writable = yes
            valid users = %S
        '';
        shares = {
            data = {
                path = "/encrypted_storage/data";
                browseable = "yes";
                public = "no";
                "read only" = "no";
                "guest ok" = "no";
                "create mask" = "0644";
                "directory mask" = "0755";
            };
        };
    };

    # Reverse proxy
    services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        # recommendedTlsSettings = true;
        virtualHosts."transmission.i.graysonhead.net" = {
            # enableACME = true;
            forceSSL = false;
            locations."/" = {
                proxyPass = "http://127.0.0.1:9091";
            };
        };
        virtualHosts."zwave.i.graysonhead.net" = {
            # enableACME = true;
            forceSSL = false;
            locations."/" = {
                proxyPass = "http://[::1]:8091";
            };
        };
        virtualHosts."home.graysonhead.net" = {
            # enableACME = true;
            forceSSL = false;
            extraConfig = ''
                proxy_buffering off;
            '';
            locations."/" = {
                proxyPass = "http://[::1]:8123";
                proxyWebsockets = true;
            };
        };
    };
        
    # DNS Configuration
    services.dns-agent.extraConfig = let
        internal_interface = "enp6s0";
    in {
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
                ];
            }
            {
                name = "graysonhead.net";
                digital_ocean_backend.api_key = "$DO_API_KEY";
                records = [
                    {
                        name = "home";
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
                ];
            }
        ];
        };
}
