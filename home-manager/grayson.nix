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
    cargo
    qgis
    gh
    inputs.mach-nix.defaultPackage.x86_64-linux
    unstable.ckan
    ltwheelconf
    unstable.calibre
    chirp
    unstable.dia
    opera
    (unstable.discord.override { nss = nss_latest; })
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
    _1password
    _1password-gui
    keybase
    keybase-gui
    unstable.vlc
    gparted
    obs-studio
    unstable.manuskript
    kdenlive
    libsForQt5.kalendar
    nodePackages.create-react-app
    nodePackages.npm
    nodejs
    unstable.k9s
    virt-manager
    youtube-dl
    terminator
    krita
    minecraft
    qt6.full
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
    ".gnupg/gpg-agent.conf" = {
      text = ''
        pinentry-program /run/current-system/sw/bin/pinentry
      '';
    };
  };
  home.activation = {
    text = ''
      chmod a+x ~
      setfacl -m u:sddm:x ~
    '';
  };
}
