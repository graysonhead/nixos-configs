{ config, pkgs, inputs, ... }:
let
  unstable-overlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ../../services/dns-agent.nix
    ];
  nixpkgs.overlays = [
    unstable-overlay
  ];

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-22605a0e-9d3d-499b-8e9b-0c8c4ce6dbae".device = "/dev/disk/by-uuid/22605a0e-9d3d-499b-8e9b-0c8c4ce6dbae";
  boot.initrd.luks.devices."luks-22605a0e-9d3d-499b-8e9b-0c8c4ce6dbae".keyFile = "/crypto_keyfile.bin";

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    enableCryptodisk = true;
  };
  boot.loader.timeout = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];
  time.timeZone = "America/Chicago";
  networking.hostName = "green";
  networking.networkmanager = {
    enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware.opengl.enable = true;
  system.stateVersion = "22.11";
  boot.kernelParams = [ "module_blacklist=i915" "GBM_BACKEND=nvidia-drm" ];
  # services.xserver.dpi = 180;
  # environment.variables = {
  #   GDK_SCALE = "2";
  #   GDK_DPI_SCALE = "0.5";
  #   _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  # };
  networking.firewall.allowedUDPPorts = [ 8765 8123 ];

  services.pipewire.extraConfig.pipewire = {
    "92-latency" = {
      "context.properties" = {
        default.clock.rate = 48000;
        default.clock.quantum = 512;
        default.clock.min-quantum = 512;
        default.clock.max-quantum = 512;
      };
    };
  };

}
