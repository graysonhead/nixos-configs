{ config, lib, pkgs, ... }:

{
  # Add htpasswd utility to system packages
  environment.systemPackages = [ pkgs.apacheHttpd ];
  # Create the public directory with users group access and htpasswd file
  systemd.tmpfiles.rules = [
    "d /encrypted_storage/data/Public 0775 root users -"
    "f /etc/nginx/htpasswd 0644 root root -"
  ];

  # Add file server virtualhost to nginx with SSL and basic auth
  services.nginx.virtualHosts."files.graysonhead.net" = {
    useACMEHost = "files.graysonhead.net";
    forceSSL = true;
    locations."/" = {
      root = "/encrypted_storage/data/Public";
      extraConfig = ''
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
        auth_basic "File Server";
        auth_basic_user_file /etc/nginx/htpasswd;
      '';
    };
  };

  # Create htpasswd file - you'll need to set passwords manually
  # Use: htpasswd -c /etc/nginx/htpasswd username
}

