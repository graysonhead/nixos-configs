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
  boot.loader.grub = {
    enable = true;
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
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  hardware.opengl.enable = true;
  system.stateVersion = "22.05";
  boot.kernelParams = [ "module_blacklist=i915" ];
  services.xserver.dpi = 180;
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

}
