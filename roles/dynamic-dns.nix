{ nixpkgs, inputs, pkgs, config, ... }:
{
  services.dns-agent.extraConfig =
    let
      internal_interface = "lan0";
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
          ];
        }
      ];
    };
}
