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

  # Optionally, specify if you'd like certain programs to use the fonts
  fonts.fontconfig.enable = true;
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML ''
      "$schema" = 'https://starship.rs/config-schema.json'

      format = """
      [](color_orange)\
      $os\
      $username\
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
      format = '[ $user ]($style)'

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
      "rust-analyzer.checkOnSave.command" = "clippy";
      "files.exclude" = {
        "**/.git" = false;
        "**/.svn" = true;
        "**/.hg" = true;
        "**/.DS_Store" = true;
        "terminal.integrated.fontFamily" = "Hack NF";
      };
    };
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      bungcip.better-toml
      formulahendry.code-runner
      golang.go
      ms-python.python
      matklad.rust-analyzer
      eamodio.gitlens
      ms-azuretools.vscode-docker
      streetsidesoftware.code-spell-checker
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.packages = with pkgs; [
    # (pkgs.writeShellApplication {
    #   name = "discord-nogl";
    #   text = "${pkgs.unstable.discord}/bin/discord --use-gl=desktop";
    # })
    # (pkgs.makeDesktopItem {
    #   name = "discord-nogl";
    #   exec = "discord-nogl";
    #   desktopName = "Discord (GPU Disabled)";
    # })
    # (pkgs.writeShellApplication {
    #   name = "slack-nogl";
    #   text = "${pkgs.unstable.slack}/bin/slack --disable-gpu";
    # })
    # (pkgs.makeDesktopItem {
    #   name = "slack-nogl";
    #   exec = "slack-nogl";
    #   desktopName = "Slack (GPU Disabled)";
    # })
    # (pkgs.writeShellApplication {
    #   name = "code-nogl";
    #   text = "${pkgs.unstable.vscode}/bin/code --disable-gpu";
    # })
    # (pkgs.makeDesktopItem {
    #   name = "code-nogl";
    #   exec = "code-nogl";
    #   desktopName = "VSCode (GPU Disabled)";
    # })
    dump1090
    cargo
    qgis
    gh
    inputs.mach-nix.defaultPackage.x86_64-linux
    unstable.ckan
    ltwheelconf
    calibre
    chirp
    element-desktop
    unstable.dia
    opera
    unstable.joplin-desktop
    unstable.signal-desktop
    gcc
    redis
    transmission-qt
    thunderbird
    unstable.wireshark
    inputs.deploy-rs.defaultPackage.x86_64-linux
    inputs.agenix.packages.x86_64-linux.agenix
    inputs.cargo2nix.packages.x86_64-linux.default
    qalculate-qt
    unstable.slack
    kubectl
    flux
    tilt
    texstudio
    texlive.combined.scheme-full
    unstable.vlc
    gparted
    obs-studio
    manuskript
    kdenlive
    nodePackages.create-react-app
    nodePackages.npm
    nodejs
    nerdfonts
    unstable.k9s
    virt-manager
    terminator
    krita
    qt6.full
    gnupg
    rpi-imager
    vulkan-tools
    git-lfs
    devenv
  ];

  programs.home-manager = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
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
    # ".gnupg/gpg-agent.conf" = {
    #   text = ''
    #     pinentry-program /run/current-system/sw/bin/pinentry
    #   '';
    # };
  };
  # home.activation = {
  #   text = ''
  #     chmod a+x ~
  #     setfacl -m u:sddm:x ~
  #   '';
  # };
}
