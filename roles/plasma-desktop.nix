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

  # xdg.portal = {
  #   enable = true;
  #   wlr = {
  #     enable = true;
  #   };
  # };

  system.nssModules = [ pkgs.nssmdns ];

  boot = {
    # silence first boot output
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.systemd.enable = true;
    kernelParams = [
      "quiet"
      "splash"
      "intremap=on"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    # plymouth, showing after LUKS unlock
    plymouth.enable = true;
    plymouth.font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
    plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
  };


  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.enableQt5Integration = true;
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.brlaser
    pkgs.brgenml1lpr
    pkgs.brgenml1cupswrapper
  ];
  hardware.bluetooth.enable = true;
  programs.kdeconnect.enable = true;
  programs.wireshark.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = false;
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
    nssmdns
    networkmanager-iodine
    networkmanager-openvpn
    networkmanager-openconnect
    nordic
    teamspeak_client
    teamspeak5_client
    zoom-us
    pass
    piper
    pinentry-curses
    kdePackages.ark
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
    kdePackages.ksshaskpass
    simple-scan
    xsane
    xsettingsd
    kdePackages.kmag
    yubikey-agent
    yubikey-manager
    yubioath-flutter
    yubico-piv-tool
    pinentry-qt
    kdePackages.kwrited
    kdePackages.filelight
    kdePackages.kate
    kdePackages.kde-gtk-config
    kdePackages.krecorder
    kdePackages.kcalc
    kdePackages.xwaylandvideobridge
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

  services.fwupd.enable = true;
}
