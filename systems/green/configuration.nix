{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../services/dns-agent.nix
    ];
  services.dns-agent.extraConfig =
    let
      internal_interface = "eno1";
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
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];
  time.timeZone = "America/Chicago";
  networking.hostName = "green";
  networking.networkmanager = {
    enable = true;
  };
  # networking.firewall.allowedUDPPorts = [ 43210 ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.opengl.enable = true;
  system.stateVersion = "22.05";
  boot.kernelParams = [ "module_blacklist=i915" ];
}
