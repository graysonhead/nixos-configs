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
    p7zip
    termdown
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
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      update = "sudo nix-collect-garbage && sudo nixos-rebuild switch --flake github:graysonhead/nixos-configs";
      rebuild-from-dir = "nixos-rebuild build --impure --flake . && sudo ./result/bin/switch-to-configuration switch && source ~/.bashrc";
      dir-size = "sudo du -shx ./* | sort -h";
      exportall = "f(){ set -o allexport; source $1; set +o allexport; }; f";
      nixrestic = "f(){ exportall /run/agenix/restic; restic -r b2:nixos-backups -p /run/agenix/restic_password $@; }; f";
      k = "kubectl";
    };
    bashrcExtra = ''
      function kns() {
        ctx=`kubectl config current-context`
        ns=$1

        # verify that the namespace exists
        ns=`kubectl get namespace $1 --no-headers --output=go-template={{.metadata.name}} 2>/dev/null`
        if [ -z "''${ns}" ]; then
          echo "Namespace (''${1}) not found, using default"
          ns="default"
        fi

        kubectl config set-context ''${ctx} --namespace="''${ns}"
      }

      function kcl() {
              clus=$1
              export KUBECONFIG=~/fa-kube/''${clus}
      }
    '';
  };

  programs.home-manager = {
    enable = true;
  };

  home.file = {
    ".tmux.conf" = {
      text = ''
        setw -g mouse on
        bind -n C-s set -g synchronize-panes
      '';
    };
    ".ssh/config" = {
      text = ''
        Host bounce
          HostName bounce.graysonhead.net

        Host lab3
                HostName localhost
                Port 15000
                ProxyJump bounce

        Host lab2
                HostName localhost
                Port 15001
                ProxyJump bounce

        Host lab1
                HostName localhost
                Port 15002
                ProxyJump bounce

        # FA specific stuff
        Host *.flightaware.com
          User grayson.head

        IdentityFile /home/grayson/.ssh/fa_id
      '';
    };
  };
}
