{ nixpkgs, pkgs, config, ... }:

let
  vpn-interface = "tun0";
in
{
  imports = [
    ../home-manager/minimal-homes.nix
    ../services/auto-dns.nix
    ../modules/common.nix
  ];
  age.secrets.ca-crt.file = ../secrets/graysonhead.net.crt.pem.age;
  age.secrets.bounce-crt.file = ../secrets/bounce.graysonhead.net.crt.pem.age;
  age.secrets.bounce-key.file = ../secrets/bounce.graysonhead.net.key.age;
  age.secrets.dh.file = ../secrets/bounce.dh.pem.age;
  networking = {
    nat = {
      enable = true;
      externalInterface = "eth0";
      internalInterfaces = [ vpn-interface ];
    };
    firewall = {
      trustedInterfaces = [ vpn-interface ];
      allowedUDPPorts = [ 1194 ];
    };
    firewall.extraCommands = ''
      # Allow IPv6 traffic for OpenVPN
      ip6tables -A INPUT -p udp --dport 1194 -j ACCEPT
      ip6tables -A FORWARD -m state --state NEW -i ${vpn-interface} -o eth0 -s 2604:a880:4:1d0::542:e000/124 -j ACCEPT
      ip6tables -A FORWARD -m state --state NEW -i ${vpn-interface} -o eth0 -s 2604:a880:4:1d0::542:e000/124 -j ACCEPT
      ip6tables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

    '';
  };
  services.openvpn = {
    servers.roadwarrior.config = ''
      dev ${vpn-interface}
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
