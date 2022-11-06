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
    };
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      bungcip.better-toml
      formulahendry.code-runner
      golang.go
      ms-python.python
      matklad.rust-analyzer
      arrterian.nix-env-selector
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
    calibre
    chirp
    dia
    rustc
    rustfmt
    rust-analyzer
    unstable.opera
    (unstable.discord.override { nss = nss_latest; })
    unstable.firefox
    unstable.joplin-desktop
    unstable.signal-desktop
    gcc
    gimp
    unstable.godot
    redis
    transmission-qt
    wireshark
    inputs.deploy-rs.defaultPackage.x86_64-linux
    inputs.agenix.defaultPackage.x86_64-linux
    inputs.cargo2nix.packages.x86_64-linux.default
    cargo
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
    vlc
    gparted
    obs-studio
    kdenlive
    poetry
    libsForQt5.kalendar
    protonmail-bridge
    nodePackages.create-react-app
    nodePackages.npm
    nodejs
    unstable.k9s
    foxitreader
    virt-manager
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
