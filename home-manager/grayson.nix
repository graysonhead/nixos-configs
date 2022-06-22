{ pkgs, inputs, ... }:
# Home manager module for full desktop installs
{
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
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.packages = with pkgs; [
    cargo
    rustc
    rustfmt
    rust-analyzer
    opera
    discord
    joplin-desktop
    signal-desktop
    gcc
    redis
    transmission-qt
    wireshark
    inputs.deploy-rs.defaultPackage.x86_64-linux
    inputs.agenix.defaultPackage.x86_64-linux
    kubectl
    flux
    tilt
    _1password
    _1password-gui
    keybase
    keybase-gui
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
  };
}
