{ pkgs, inputs, nixpkgs, ... }:
# Home manager module for full desktop installs
{
  imports = [
    ../modules/protonmail-bridge.nix
  ];
  services.protonmail-bridge = {
    enable = true;
    nonInteractive = true;
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      bungcip.better-toml
      formulahendry.code-runner
      golang.go
      ms-python.python
      matklad.rust-analyzer
      arrterian.nix-env-selector
      eamodio.gitlens
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.packages = with pkgs; [
    calibre
    cargo
    chirp
    rustc
    rustfmt
    rust-analyzer
    opera
    (unstable.discord.override { nss = pkgs.nss_latest; })
    joplin-desktop
    signal-desktop
    gcc
    gimp
    redis
    transmission-qt
    wireshark
    inputs.deploy-rs.defaultPackage.x86_64-linux
    inputs.agenix.defaultPackage.x86_64-linux
    slack
    kubectl
    flux
    tilt
    _1password
    _1password-gui
    keybase
    keybase-gui
    vlc
    gparted
    obs-studio
    kdenlive
    poetry
    protonmail-bridge
    inputs.cargo2nix.packages.x86_64-linux.cargo2nix
    nodePackages.create-react-app
    nodePackages.npm
    nodejs
    k9s
    libsForQt5.kmail
    libsForQt5.kwrited
  ];

  programs.home-manager = {
    enable = true;
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home.file = {
    ".config/discord/settings.json" = {
      text = ''
        "SKIP_HOST_UPDATE": true
      '';
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
}
