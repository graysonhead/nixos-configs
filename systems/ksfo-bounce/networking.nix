{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
    ];
    defaultGateway = "146.190.128.1";
    defaultGateway6 = {
      address = "2604:a880:4:1d0::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "146.190.137.22"; prefixLength = 20; }
          { address = "10.48.0.5"; prefixLength = 16; }
        ];
        ipv6.addresses = [
          { address = "2604:a880:4:1d0::542:e000"; prefixLength = 64; }
          { address = "fe80::863:7eff:fee9:fdf6"; prefixLength = 64; }
        ];
        ipv4.routes = [{ address = "146.190.128.1"; prefixLength = 32; }];
        ipv6.routes = [{ address = "2604:a880:4:1d0::1"; prefixLength = 128; }];
      };
      eth1 = {
        ipv4.addresses = [
          { address = "10.124.0.2"; prefixLength = 20; }
        ];
        ipv6.addresses = [
          { address = "fe80::2467:49ff:febf:7d5a"; prefixLength = 64; }
        ];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="0a:63:7e:e9:fd:f6", NAME="eth0"
    ATTR{address}=="26:67:49:bf:7d:5a", NAME="eth1"
  '';
}
