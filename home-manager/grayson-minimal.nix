{ pkgs, ... }:
# Minimal home manager module for CLI only systems
{
  home.stateVersion = "21.11";
  home.packages = with pkgs; [
    vim
    bind
    pciutils
    tmux
    htop
    nmon
    screen
    unzip
  ];
  home.sessionVariables = rec {
    CARGO_NET_GIT_FETCH_WITH_CLI = "true";
    EDITOR = "vim";
  };

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Grayson Head";
    userEmail = "grayson@graysonhead.net";
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild-from-dir = "nixos-rebuild build --impure --flake . && sudo ./result/bin/switch-to-configuration switch";
      dir-size = "sudo du -shx ./* | sort -h";
      exportall = "f(){ set -o allexport; source $1; set +o allexport; }; f";
      nixrestic = "f(){ exportall /run/agenix/restic; restic -r b2:nixos-backups -p /run/agenix/restic_password $@; }; f";
    };
  };

  programs.home-manager = {
    enable = true;
  };

  home.file = {
    ".tmux.conf" = {
      text = ''
        setw -g mouse on
        bind -n -C-s set-window-option synchronize-panes
      '';
    };
  };
}
