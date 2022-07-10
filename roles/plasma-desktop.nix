{ nixpkgs, pkgs, inputs, lib, ... }:

let
  nss-mdns-overlay = (self: super: {
    nssmdns = super.nssmdns.overrideAttrs (prev: {
      version = "v0.15.1";
      src = pkgs.fetchFromGitHub {
        owner = "lathiat";
        repo = "nss-mdns";
        rev = "v0.15.1";
        sha256 = "sha256-iRaf9/gu9VkGi1VbGpxvC5q+0M8ivezCz/oAKEg5V1M=";
      };
      patches = [ ];
      buildInputs = [ pkgs.autoreconfHook pkgs.pkg-config ];
    });
  });
in
{
  imports = [
    ../home-manager/full-homes.nix
    ../modules/common.nix
    ../services/syncthing.nix
    ../modules/home-backups.nix
  ];

  nixpkgs.overlays = [ nss-mdns-overlay ];

  system.nssDatabases.hosts = (lib.mkMerge [
    (lib.mkBefore [ "mdns4_minimal [NOTFOUND=return]" ])
    (lib.mkAfter [ "mdns4" ])
  ]);

  system.nssModules = [ pkgs.nssmdns ];

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.brlaser
    pkgs.brgenml1lpr
    pkgs.brgenml1cupswrapper
  ];
  services.keybase.enable = true;
  programs.steam = {
    enable = true;
  };
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.bluetooth.enable = true;
  programs.kdeconnect.enable = true;
  programs.wireshark.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = false;
    ipv6 = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
      workstation = true;
      hinfo = true;
    };
  };
  services.flatpak.enable = true;
  programs.ssh.startAgent = true;
  environment.systemPackages = with pkgs; [
    firefox
    networkmanager-iodine
    networkmanager-openvpn
    networkmanager-openconnect
    nordic
    slack
    discord
    teamspeak_client
    zoom-us
    lutris
    ark
    minikube
    openvpn
    iodine
    python310Packages.protonup
    protontricks
    xorg.xkill
    winetricks
    wine
    os-prober
    fuseiso
    exfat
    ntfs3g
    ksshaskpass
  ];
  programs.adb.enable = true;
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  # };
  virtualisation.docker.enable = true;
}
