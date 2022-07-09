{ nixpkgs, pkgs, inputs, ... }:

{
  imports = [
    ../home-manager/full-homes.nix
    ../modules/common.nix
    ../services/syncthing.nix
    ../modules/home-backups.nix
  ];
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
    nssmdns = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
      workstation = true;
      hinfo = true;
    };
  };
  networking.firewall.allowedUDPPorts = [ 5353 ];
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
