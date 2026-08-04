{ nixpkgs, pkgs, inputs, lib, config, ... }:

let
  unstable-overlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  };
  # i686 pipewire (pulled in by the bottles FHS environment) enables several
  # optional plugins whose i686 builds are not in the binary cache, forcing
  # local compilation of heavy deps like openblas/numpy/roc-toolkit/scons.
  # None of these features are needed for these systems (yet).
  no-i686-heavy-overlay = final: prev: {
    pkgsi686Linux = prev.pkgsi686Linux.extend (_: p: {
      pipewire = (p.pipewire.override {
        ffadoSupport = false; # FireWire audio - not present on any machine here
        rocSupport = false; # ROC network audio - pulls in scons/roc-toolkit
        onnxruntimeSupport = false; # ML inference - unnecessary for Wine audio
      }).overrideAttrs (old: {
        # libcamera must be disabled at the meson level too, not just removed from inputs
        buildInputs = builtins.filter (x: (x.pname or "") != "libcamera") (old.buildInputs or [ ]);
        mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dlibcamera=disabled" ];
      });
    });
  };
in
{
  imports = [
    ../modules/common.nix
    ../modules/probe-rs-udev.nix
    ../modules/picotool-udev.nix
    ../services/syncthing.nix
    ../modules/home-backups.nix
    ../services/auto-dns.nix
    inputs.parental-controls.nixosModules.parental-controls-agent
  ];

  services.parental-controls-agent = {
    enable = true;
    serverUrl = "https://parental-controls.graysonhead.net";
    children = {
      "Wyatt" = "wyatt";
      "Owen" = "owen";
    };
  };
  nixpkgs.overlays = [
    unstable-overlay
    no-i686-heavy-overlay
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

  # Firefox with custom search engines
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      OfferToSaveLogins = false;
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
      };
      SearchEngines = {
        Add = [
          {
            Name = "GraysonHead Search";
            URLTemplate = "https://search.graysonhead.net/search?q={searchTerms}";
            Method = "GET";
            IconURL = "https://search.graysonhead.net/favicon.ico";
            Alias = "@search";
            Description = "Search via search.graysonhead.net";
          }
          {
            Name = "NixOS Packages";
            URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
            Method = "GET";
            IconURL = "https://search.nixos.org/favicon.ico";
            Alias = "@nixpkgs";
            Description = "Search NixOS packages";
          }
          {
            Name = "NixOS Options";
            URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
            Method = "GET";
            IconURL = "https://search.nixos.org/favicon.ico";
            Alias = "@nixoptions";
            Description = "Search NixOS options";
          }
        ];
        Default = "GraysonHead Search";
      };
    };
  };
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

  # Expose NixOS fonts to flatpak sandboxed apps via /usr/share/fonts
  fonts.fontDir.enable = true;
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems."/usr/share/fonts" = {
    device = "/run/current-system/sw/share/X11/fonts";
    fsType = "fuse.bindfs";
    options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
  };
  programs.ssh.startAgent = true;
  services.usbmuxd.enable = true;
  services.pcscd.enable = true;
  services.ratbagd.enable = true;
  programs.gnupg.agent.enable = false;
  environment.systemPackages = with pkgs; [
    gimp
    appimage-run
    bitwarden-desktop
    bitwarden-cli
    ifuse
    libimobiledevice
    libheif
    kdePackages.kio-fuse
    nssmdns
    networkmanager-iodine
    networkmanager-openvpn
    networkmanager-openconnect
    nordic
    teamspeak6-client
    zoom-us
    pass
    piper
    pinentry-curses
    kdePackages.ark
    minikube
    openvpn
    iodine
    protonup-ng
    libreoffice-qt
    hunspellDicts.en_US
    protontricks
    xkill
    winetricks
    wineWow64Packages.stable
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
    # xwaylandvideobridge # Removed in NixOS 25.11 - KDE Gear 5/Plasma 5 EOL
    opendrop
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    gamescope
    mangohud
    iotop
    picocom
    minicom
    android-tools
  ];
  services.yubikey-agent.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;
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
    wireplumber.extraConfig = {
      # libcamera's UVC pipeline handler segfaults/aborts probing the
      # Logitech C925e; it's only needed for MIPI/CSI sensors anyway, not
      # standard UVC webcams, so just disable the monitor.
      "51-disable-libcamera" = {
        "wireplumber.profiles" = {
          main = {
            "monitor.libcamera" = "disabled";
          };
        };
      };
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
    "qtwebengine-5.15.19"
    # bitwarden-desktop 2026.5.0 depends on electron-39 (EOL); remove when upstream updates
    "electron-39.8.10"
  ];

  # Set limits for esync.
  systemd.settings.Manager.DefaultLimitNOFILE = 1048576;

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



  # NetworkManager plugins
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
    networkmanager-openconnect
    networkmanager-iodine
  ];

  # Fixes iotop
  boot.kernel.sysctl = { "kernel.task_delayacct" = 1; };

  # boot.kernelPackages = with pkgs; unstable.linuxPackages;

  services.fwupd.enable = true;
}
