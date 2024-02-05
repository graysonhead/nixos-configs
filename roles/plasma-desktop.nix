{ nixpkgs, pkgs, inputs, lib, config, ... }:

let
  unstable-overlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  };
  fontsPkg = pkgs: (pkgs.runCommand "share-fonts" { preferLocalBuild = true; } ''
    mkdir -p "$out/share/fonts"
    font_regexp='.*\.\(ttf\|ttc\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
    find ${toString (config.fonts.fonts)} -regex "$font_regexp" \
      -exec ln -sf -t "$out/share/fonts" '{}' \;
  '');
in
{
  imports = [
    ../modules/common.nix
    ../services/syncthing.nix
    ../modules/home-backups.nix
    ../services/auto-dns.nix
  ];
  nixpkgs.overlays = [
    unstable-overlay
  ];

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
  services.kbfs.enable = true;
  services.keybase.enable = true;
  hardware.steam-hardware.enable = true;
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
  services.usbmuxd.enable = true;
  services.pcscd.enable = true;
  services.ratbagd.enable = true;
  programs.gnupg.agent.enable = false;
  environment.systemPackages = with pkgs; [
    gimp
    appimage-run
    bitwarden
    bitwarden-cli
    ifuse
    libimobiledevice
    libheif
    kio-fuse
    unstable.nssmdns
    networkmanager-iodine
    networkmanager-openvpn
    networkmanager-openconnect
    nordic
    teamspeak_client
    teamspeak5_client
    unstable.zoom-us
    pass
    piper
    pinentry-curses
    ark
    minikube
    openvpn
    iodine
    python310Packages.protonup
    libreoffice-qt
    hunspellDicts.en_US
    protontricks
    xorg.xkill
    winetricks
    wineWowPackages.stable
    os-prober
    fuseiso
    exfat
    ntfs3g
    ksshaskpass
    gnome.simple-scan
    xsane
    xsettingsd
    kmag
    yubikey-agent
    yubikey-manager
    yubikey-manager-qt
    yubico-piv-tool
    pinentry-qt
    libsForQt5.kdeApplications.akonadi
    libsForQt5.kdeApplications.akonadiconsole
    libsForQt5.kdeApplications.akonadi-search
    libsForQt5.akonadi-mime
    libsForQt5.akonadi-calendar
    libsForQt5.akonadi-mime
    libsForQt5.kontact
    libsForQt5.kmail
    libsForQt5.kwrited
    libsForQt5.kontact
    libsForQt5.korganizer
    libsForQt5.filelight
    libsForQt5.kate
    libsForQt5.kde-gtk-config
    libsForQt5.krecorder
    libsForQt5.kcalc
    opendrop
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    gamescope
    mangohud
    iotop
  ];
  services.yubikey-agent.enable = true;
  programs.adb.enable = true;
  virtualisation.docker.enable = true;
  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
    };
    brscan5 = {
      enable = true;
    };
    extraBackends = [
      pkgs.sane-airscan
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];

  # Set limits for esync.
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  security.pam.loginLimits = [{
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "1048576";
  }];
  networking.extraHosts = ''
  '';
  programs.xwayland.enable = true;

  nix.settings.trusted-users = [ "root" "grayson" ];


  # Fixes iotop
  boot.kernel.sysctl = { "kernel.task_delayacct" = 1; };

  boot.kernelPackages = with pkgs; unstable.linuxPackages;
}
