{ pkgs, config, ... }:
# Minimal home manager module for CLI only systems
{
  home.stateVersion = "21.11";
  home.packages = with pkgs; [
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
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Grayson Head";
    userEmail = "grayson@graysonhead.net";
    extraConfig = {
      init.defaultBranch = "main";
      filter.lfs.clean = "git-lfs clean -- %f";
      filter.lfs.smudge = "git-lfs smudge -- %f";
      filter.lfs.process = "git-lfs filter-process";
      filter.lfs.required = true;
    };
    signing = {
      key = "1F5820610A829D10BE2D236A3ED82391AFC8671F";
    };
    extraConfig = {
      pull = {
        rebase = "false";
      };
      credential = {
        helper = "store";
      };
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    coc.enable = true;
    plugins = with pkgs.vimPlugins; [
      ale
      autoclose-nvim
      vim-airline
      rust-vim
      direnv-vim
      nerdtree
      coc-rust-analyzer
      coc-nvim
      coc-pyright
      coc-spell-checker
      vim-elixir
    ];
    #settings = { ignorecase = true; };
    extraConfig = ''
       colorscheme slate
      
       set mouse=a
       set nocompatible
       filetype off
       set encoding=utf-8
       set termguicolors
       set spell spelllang=en_us

       let g:rustfmt_autosave = 1
       let g:rustfmt_emit_files = 1
       let g:rustfmt_fail_silently = 0

        function! StartUp()
         if !argc() && !exists("s:std_in")
           NERDTree
         end
         if argc() && isdirectory(argv()[0]) && !exists("s:std_in")
          exe 'NERDTree' argv()[0]
          wincmd p
          ene
         end
       endfunction

       autocmd StdinReadPre * let s:std_in=1
       autocmd VimEnter * call StartUp()

      " " Auto close with matching bracket
      inoremap { {}<c-g>U<left>

      " " if between 2 brackets: "enter" to start inserting between them                                                             
      " inoremap <expr> <cr> getline('.')[col('.')-2:col('.')-1]=='{}' ? '<cr><esc>O' : '<cr>'

      " " If on a closing bracket: trying to reclose just skips the character
      " inoremap <expr> } getline('.')[col('.')-1]=='}' ? '<c-g>U<right>' : '}'

      " inoremap { {}<Esc>ha
      " inoremap ( ()<Esc>ha
      " inoremap [ []<Esc>ha
      " inoremap " ""<Esc>ha
      " inoremap ' '''<Esc>ha
      " inoremap ` ``<Esc>ha
      inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
      inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
      inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
    '';
  };

  programs.bash = {
    enable = true;
    # initExtra = ''
    #   . \"$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh\"
    # '';
    shellAliases = {
      update = "sudo nixos-rebuild boot --flake github:graysonhead/nixos-configs && sudo shutdown -r now";
      rebuild-from-dir = "nixos-rebuild build --impure --flake . && sudo ./result/bin/switch-to-configuration switch && source ~/.bashrc";
      dir-size = "sudo du -shx ./* | sort -h";
      exportall = "f(){ set -o allexport; source $1; set +o allexport; }; f";
      nixrestic = "f(){ exportall /run/agenix/restic; restic -r b2:nixos-backups -p /run/agenix/restic_password $@; }; f";
      bluerestic = "f(){ exportall /run/agenix/restic; restic -r b2:ghead-blue-backup -p /run/agenix/restic_password $@; }; f";
      tilt-hardreset = "tilt down && minikube delete && minikube start && tilt up";
      tilt-up = "minikube start && tilt up";
      tilt-down = "tilt down &&  minikube stop";
      k = "kubectl";
      list-generations = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
    };
    bashrcExtra = ''
      export TERM='xterm-256color'
      export PATH=~/.npm-packages/bin:$PATH
      export PATH=~/.cargo/bin/:$PATH
      export NODE_PATH=~/.npm-packages/lib/node_modules
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
    # Use same configs and store for joplin desktop and cli
    ".config/joplin".source = config.lib.file.mkOutOfStoreSymlink "~.config/joplin-desktop";
    ".vim/coc-settings.json" = {
      text = builtins.toJSON {
        rust-analyzer = {
          enable = true;
          checkOnSave.command = "clippy";
        };
        pyright = {
          enable = true;
        };
        diagnostic.errorSign = "X";
        diagnostic.infoSign = "i";
        languageserver = {
          rust = {
            command = "rust-analyzer";
            filetypes = [ "rust" ];
            rootPatterns = [ "Cargo.toml" ];
          };
        };
      };
    };
    ".npmrc" = {
      text = ''
        prefix = ''${HOME}/.npm-packages
      '';
    };
    ".iex.exs" = {
      text = ''
      IEx.configure colors: [ eval_result: [:cyan, :bright]]
      '';
    };
    ".tmux.conf" = {
      text = ''
        unbind '"'
        unbind "%"
        setw -g mouse on
        bind C-s set -g synchronize-panes
        bind | split-window -h
        bind _ split-window -v
      '';
    };
    ".ssh/config" = {
      text = ''
        Host bounce
          HostName bounce.graysonhead.net
          ForwardAgent yes
        
        Host teamspeak.lazerhawks.net
          Port 922
          HostKeyAlgorithms +ssh-rsa
          PubkeyAcceptedKeyTypes +ssh-rsa

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
          ForwardAgent yes
        Host *.hou
          User grayson.head
          ForwardAgent yes
        Host *.dal
          User grayson.head
          ForwardAgent yes

        IdentityFile /home/grayson/.ssh/id_fa
      '';
    };
  };
}
