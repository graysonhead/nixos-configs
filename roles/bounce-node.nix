{ nixpkgs, pkgs, config, ... }:

let
  vpn-interface = "tun0";
  external-interface = "eth0";
in
{
  imports = [
    ../home-manager/minimal-homes.nix
    ../services/dns-agent.nix
    ../services/auto-dns.nix
    ../modules/common.nix
  ];
  age.secrets.ca-crt.file = ../secrets/graysonhead.net.crt.pem.age;
  age.secrets.bounce-crt.file = ../secrets/bounce.graysonhead.net.crt.pem.age;
  age.secrets.bounce-key.file = ../secrets/bounce.graysonhead.net.key.age;
  age.secrets.dh.file = ../secrets/bounce.dh.pem.age;
  services.dns-agent.extraConfig = {
    domains = [
      {
        name = "graysonhead.net";
        cloudflare_backend = {
          api_token = "$CF_API_TOKEN";
          zone_identifier = "$CF_GRAYSONHEAD_NET_ZONE_IDENTIFIER";
          zone = "graysonhead.net";
        };
        records = [
          {
            name = "${config.networking.hostName}";
            record_type = "A";
            interface = "external";
          }
          {
            name = "${config.networking.hostName}";
            record_type = "AAAA";
            interface = "${external-interface}";
          }
        ];
      }
    ];
  };
  networking = {
    nat = {
      enable = true;
      externalInterface = "${external-interface}";
      internalInterfaces = [ vpn-interface ];
    };
    firewall = {
      trustedInterfaces = [ vpn-interface ];
      allowedUDPPorts = [ 1194 ];
      checkReversePath = "loose";
    };
    firewall.extraCommands = ''
      # Allow IPv6 traffic for OpenVPN
      echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
      ip6tables -A INPUT -p udp --dport 1194 -j ACCEPT
      ip6tables -A FORWARD -m state --state NEW -i ${vpn-interface} -o ${external-interface} -s 2604:a880:4:1d0::542:e000/124 -j ACCEPT
      ip6tables -A FORWARD -m state --state NEW -i ${vpn-interface} -o ${external-interface} -s 2604:a880:4:1d0::542:e000/124 -j ACCEPT
      ip6tables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
    '';
  };
  services.openvpn = {
    servers.roadwarrior.config = ''
      dev ${vpn-interface}
      proto udp6
      persist-key
      persist-tun
      verb 3
      explicit-exit-notify 1
      ca ${config.age.secrets.ca-crt.path}
      cert ${config.age.secrets.bounce-crt.path}
      key ${config.age.secrets.bounce-key.path}
      dh ${config.age.secrets.dh.path}
      server 10.4.0.0 255.255.255.0
      server-ipv6 2604:a880:4:1d0::542:e000/124
      push "redirect-gateway ipv6 def1 bypass-dhcp"
      client-to-client
      keepalive 10 120
      cipher AES-256-CBC

      # Uncomment for multi-cilent per cert
      ;duplicate-cn
    '';
  };
}
