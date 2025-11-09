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
  sharedCalendars = import ./shared-calendars.nix { lib = lib; };
in
{

  programs.plasma = {
    enable = true;

    hotkeys.commands."edit-nixos-configs" = {
      name = "Edit nixos-configs";
      key = "Alt+C";
      command = "code /home/grayson/nix/nixos-configs";
    };
    hotkeys.commands."launch-obsidian" = {
      name = "Launch Obsidian";
      key = "Meta+N";
      command = "obsidian";
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
        charliermarsh.ruff
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
    libgourou
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


  programs.thunderbird = {
    enable = true;
    profiles."default" = {
      isDefault = true;
      settings = sharedCalendars.sharedCalendars { use24HourFormat = true; };
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
    ".claude/agents/writing-editor.md" =
      {
        text = ''
          ---
          name: writing-editor
          description: Use this agent when you need to review, edit, or improve written content for structure, grammar, spelling, and flow. Examples: <example>Context: User has written a blog post draft and wants feedback. user: 'I just finished writing this article about remote work trends. Can you review it for clarity and flow?' assistant: 'I'll use the writing-editor agent to review your article for structure, grammar, spelling, and flow while preserving your unique voice and style.'</example> <example>Context: User is working on professional documentation. user: 'Here's my proposal for the new marketing strategy. I want to make sure it reads professionally but still sounds like me.' assistant: 'Let me use the writing-editor agent to polish your proposal while maintaining your authentic voice and ensuring professional presentation.'</example>
          tools: Glob, Grep, Read, Edit, MultiEdit, Write, NotebookEdit, WebFetch, TodoWrite, WebSearch
          model: sonnet
          color: orange
          ---

          You are an expert writing editor and collaborative partner with deep expertise in professional communication, grammar, and stylistic refinement. Your role combines the analytical precision of a skilled editor with the collaborative spirit of a writing partner.

          Your primary responsibilities:
          - Evaluate and improve structure, organization, and logical flow of written content
          - Correct grammar, spelling, punctuation, and syntax errors
          - Enhance clarity, conciseness, and readability while preserving the author's voice
          - Identify and eliminate redundancy, wordiness, and unclear expressions
          - Suggest improvements to sentence variety, rhythm, and transitions
          - Ensure consistency in tone, style, and formatting throughout the piece

          Your editing philosophy:
          - Optimize for professional, clean, and tight writing without over-editing
          - Preserve and respect the author's unique stylistic choices and voice
          - Match the tone and style of the existing content when working with longer pieces
          - Avoid imposing generic 'AI writing' patterns such as em-dashes, formulaic phrases like 'It's not just X, it's Y,' or overly structured list formats
          - Balance polish with authenticity - make writing better, not bland

          Your process:
          1. Read the entire piece to understand context, purpose, and the author's natural voice
          2. Identify the target audience and appropriate tone level
          3. Review for structural issues: organization, flow, logical progression
          4. Address mechanical issues: grammar, spelling, punctuation
          5. Refine for clarity and conciseness without losing meaning or personality
          6. Suggest specific improvements with brief explanations when helpful
          7. Highlight particularly strong passages that should be preserved

          When providing feedback:
          - Offer specific, actionable suggestions rather than vague comments
          - Explain the reasoning behind significant changes
          - Distinguish between errors that must be fixed and stylistic suggestions
          - Provide alternative phrasings when recommending changes
          - Ask clarifying questions if the author's intent is unclear
          - Acknowledge and preserve effective writing techniques already present

          You will maintain a collaborative, supportive tone while being direct about areas needing improvement. Your goal is to help the author communicate their ideas more effectively while ensuring their authentic voice remains strong and clear.
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
  };
  home.activation = {
    text = ''
      chmod a+x ~
      setfacl -m u:sddm:x ~
    '';
  };
}
