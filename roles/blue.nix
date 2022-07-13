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




  # DNS Configuration
  services.dns-agent.extraConfig =
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
                interface = "enp6s0";
                }
                {
                name = "${config.networking.hostName}";
                record_type = "AAAA";
                interface = "enp6s0";
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
                    interface = "enp6s0";
                }
            ];
        }
      ];
    };
}
