{ pkgs, inputs, nixpkgs, config, lib, ... }:
# Home manager module for full desktop installs
let
  defaultIconFileName = "g.icon";
  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/icons/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = { fileName = defaultIconFileName; };
  };
in
{

  programs.plasma = {
    enable = true;

    hotkeys.commands."edit-nixos-configs" = {
      name = "Edit nixos-configs";
      key = "Alt+C";
      command = "code /home/grayson/nix/nixos-configs";
    };
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";

  };

  # Optionally, specify if you'd like certain programs to use the fonts
  fonts.fontconfig.enable = true;
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML ''
      "$schema" = 'https://starship.rs/config-schema.json'

      format = """
      [](color_orange)\
      $os\
      $username$hostname\
      [](bg:color_yellow fg:color_orange)\
      $directory\
      [](fg:color_yellow bg:color_aqua)\
      $git_branch\
      $git_status\
      [](fg:color_aqua bg:color_blue)\
      $c\
      $rust\
      $golang\
      $nodejs\
      $php\
      $java\
      $kotlin\
      $haskell\
      $python\
      [](fg:color_blue bg:color_bg3)\
      $docker_context\
      $conda\
      [](fg:color_bg3 bg:color_bg1)\
      $time\
      [ ](fg:color_bg1)\
      $line_break$character"""

      palette = 'gruvbox_dark'

      [palettes.gruvbox_dark]
      color_fg0 = '#fbf1c7'
      color_bg1 = '#3c3836'
      color_bg3 = '#665c54'
      color_blue = '#458588'
      color_aqua = '#689d6a'
      color_green = '#98971a'
      color_orange = '#d65d0e'
      color_purple = '#b16286'
      color_red = '#cc241d'
      color_yellow = '#d79921'

      [os]
      disabled = false
      style = "bg:color_orange fg:color_fg0"

      [hostname]
      ssh_only = true
      format = "[@$hostname]($style)"
      trim_at = "."
      disabled = false
      style = "bg:color_orange fg:color_fg0"


      [os.symbols]
      Windows = "󰍲"
      Ubuntu = "󰕈"
      SUSE = ""
      Raspbian = "󰐿"
      Mint = "󰣭"
      Macos = "󰀵"
      Manjaro = ""
      Linux = "󰌽"
      Gentoo = "󰣨"
      Fedora = "󰣛"
      Alpine = ""
      Amazon = ""
      Android = ""
      Arch = "󰣇"
      Artix = "󰣇"
      CentOS = ""
      Debian = "󰣚"
      Redhat = "󱄛"
      RedHatEnterprise = "󱄛"
      NixOS = ""

      [username]
      show_always = true
      style_user = "bg:color_orange fg:color_fg0"
      style_root = "bg:color_orange fg:color_fg0"
      format = '[ $user]($style)'

      [directory]
      style = "fg:color_fg0 bg:color_yellow"
      format = "[ $path ]($style)"
      truncation_length = 3
      truncation_symbol = "…/"

      [directory.substitutions]
      "Documents" = "󰈙 "
      "Downloads" = " "
      "Music" = "󰝚 "
      "Pictures" = " "
      "Developer" = "󰲋 "

      [git_branch]
      symbol = ""
      style = "bg:color_aqua"
      format = '[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)'

      [git_status]
      style = "bg:color_aqua"
      format = '[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)'

      [nodejs]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [c]
      symbol = " "
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [rust]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [golang]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [php]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [java]
      symbol = " "
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [kotlin]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [haskell]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [python]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [docker_context]
      symbol = ""
      style = "bg:color_bg3"
      format = '[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)'

      [conda]
      style = "bg:color_bg3"
      format = '[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)'

      [time]
      disabled = false
      time_format = "%R"
      style = "bg:color_bg1"
      format = '[[  $time ](fg:color_fg0 bg:color_bg1)]($style)'

      [line_break]
      disabled = false

      [character]
      disabled = false
      success_symbol = '[](bold fg:color_green)'
      error_symbol = '[](bold fg:color_red)'
      vimcmd_symbol = '[](bold fg:color_green)'
      vimcmd_replace_one_symbol = '[](bold fg:color_purple)'
      vimcmd_replace_symbol = '[](bold fg:color_purple)'
      vimcmd_visual_symbol = '[](bold fg:color_yellow)'
    '';
  };
  imports = [
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      userSettings = {
        "git.enableCommitSigning" = true;
        "workbench.colorTheme" = "Default Dark+";
        "files.autoSave" = "afterDelay";
        "git.confirmSync" = false;
        "explorer.confirmDelete" = false;
        "security.workspace.trust.untrustedFiles" = "open";
        "diffEditor.ignoreTrimWhitespace" = false;
        "explorer.confirmDragAndDrop" = false;
        "editor.formatOnSave" = true;
        "rust-analyzer.checkOnSave" = true;
        "files.exclude" = {
          "**/.git" = false;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/.DS_Store" = true;
          "terminal.integrated.fontFamily" = "Hack NF";
        };
        "nix.formatterPath" = "nixpkgs-fmt";
      };
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        bungcip.better-toml
        formulahendry.code-runner
        golang.go
        ms-python.python
        rust-lang.rust-analyzer
        eamodio.gitlens
        ms-azuretools.vscode-docker
        streetsidesoftware.code-spell-checker
        pkgs.unstable.vscode-extensions.saoudrizwan.claude-dev
      ];
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.packages = with pkgs; [
    google-chrome
    dump1090
    cargo
    # rust-analyzer # This has a tendancy to cause issue with dev flakes, as for some reason this version takes precedence with VSCode
    clippy
    rustfmt
    qgis
    gh
    ckan
    calibre
    chirp
    chromium
    element-desktop
    dia
    joplin-desktop
    gcc
    redis
    transmission_4-qt
    wireshark
    inputs.deploy-rs.packages.x86_64-linux.deploy-rs
    inputs.agenix.packages.x86_64-linux.agenix
    inputs.cargo2nix.packages.x86_64-linux.default
    qalculate-qt
    slack
    exercism
    kubectl
    flux
    tilt
    texstudio
    texlive.combined.scheme-full
    unstable.vlc
    gparted
    unstable.obs-studio
    manuskript
    kdePackages.kdenlive
    nodePackages.npm
    nodejs
    nerd-fonts.hack
    unstable.k9s
    virt-manager
    terminator
    krita
    qt6.full
    gnupg
    rpi-imager
    vulkan-tools
    git-lfs
    unstable.devenv
    obsidian
    nixpkgs-fmt
    unstable.claude-code
    # (python311.withPackages (ps: with ps; [
    #   requests
    #   pip
    #   numpy
    #   scipy
    #   flake8
    #   pytest
    #   coverage
    #   cython
    #   wheel
    #   # Currently broken
    #   # jupyterlab
    #   flax
    #   matplotlib
    # ]))
  ];

  programs.home-manager = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        DisableTelemetry = true;
        OfferToSaveLogins = false;
      };
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles."default" = {
      isDefault = true;
      settings = {
        # Auto-enable extensions
        "extensions.autoDisableScopes" = 0;

        # Calendar configuration
        "calendar.timezone.local" = "America/Chicago";
        "calendar.timezone.useSystemTimezone" = true;
        "calendar.ui.version" = 3;

        # Main Calendar (Grayson's Calendar)
        "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.cache.enabled" = true;
        "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.calendar-main-in-composite" = true;
        "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.color" = "#3d3846";
        "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.disabled" = false;
        "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.name" = "Grayson's Calendar";
        "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.readOnly" = false;
        "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.refreshInterval" = "5";
        "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.suppressAlarms" = false;
        "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.type" = "caldav";
        "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.uri" = "https://calendar.graysonhead.net/ghead/58b3381d-c909-44b8-d92a-8c220c54874e/";
        "calendar.registry.c0531f6c-889f-48ca-b5c4-ceab6d55b896.username" = "ghead";

        # Family Calendar
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.cache.enabled" = true;
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.calendar-main-default" = true;
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.calendar-main-in-composite" = true;
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.color" = "#f5c211";
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.disabled" = false;
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.name" = "Family Calendar";
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.readOnly" = false;
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.refreshInterval" = "5";
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.suppressAlarms" = false;
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.type" = "caldav";
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.uri" = "https://calendar.graysonhead.net/ghead/438917c6-82a6-7d8e-8f5f-b01190f02147/";
        "calendar.registry.f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7.username" = "ghead";

        # Oncall Calendar
        "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.cache.enabled" = true;
        "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.calendar-main-in-composite" = true;
        "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.color" = "#99ffff";
        "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.disabled" = false;
        "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.name" = "Oncall";
        "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.readOnly" = true;
        "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.refreshInterval" = "30";
        "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.suppressAlarms" = false;
        "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.type" = "ics";
        "calendar.registry.b211e8d1-b459-40a1-aaf2-551362c9a426.uri" = "https://cloudflare.pagerduty.com/private/c445b47257761cc27746a1d317b015851ba473084d5a3ed5c63750ff3f32efe2/feed";

        # Calendar list order (updated to include oncall calendar)
        "calendar.list.sortOrder" = "f45b781a-f0bc-4be1-96eb-8ce4e8bb73b7 c0531f6c-889f-48ca-b5c4-ceab6d55b896 b211e8d1-b459-40a1-aaf2-551362c9a426";
      };
    };
  };

  accounts.email = {
    accounts.fastmail = {
      address = "grayson@graysonhead.net";
      realName = "Grayson Head";
      primary = true;
      thunderbird = {
        enable = true;
        profiles = [ "default" ];
      };
      imap = {
        host = "imap.fastmail.com";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.fastmail.com";
        port = 465;
        tls.enable = true;
      };
      userName = "grayson@graysonhead.net";
    };
  };


  services.kdeconnect = {
    enable = true;
    indicator = false;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  home.file = {
    ".face.icon" = {
      source = defaultIcon;
    };
    ".config/plasma-workspace/env/ssh-agent-startup.sh" = {
      text = ''
        #!/bin/bash

        [ -z "$SSH\_AGENT\_PID" ] || eval "$(ssh-agent -s)"
      '';
      executable = true;
    };
    ".config/autostart-scripts/ssh-add.sh" = {
      text = ''
        #!/bin/bash

        export SSH\_ASKPASS=/usr/bin/ksshaskpass
        ssh-add $HOME/.ssh/id_fa
      '';
      executable = true;
    };
  };
  home.activation = {
    text = ''
      chmod a+x ~
      setfacl -m u:sddm:x ~
    '';
  };
}
