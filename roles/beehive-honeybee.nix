{ inputs, config, pkgs, ... }:

let
  configYaml = pkgs.writeText "beehive-config.yaml" ''
    gpg_home: /var/lib/honeybee/.config/beehive/gnupg
    gpg_recipient: beehive@localhost
    agent_cmd: opencode
    agent_ephemeral: true
    model: ollama/qwen2.5-coder:32b
    ttl_minutes: 60
    max_turns: 30
    reject_limit: 3
  '';

  opencodeJson = pkgs.writeText "opencode.json" (builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    provider.ollama = {
      npm = "@ai-sdk/openai-compatible";
      name = "Ollama (local)";
      options.baseURL = "http://localhost:11434/v1";
      models."qwen2.5-coder:32b".name = "Qwen2.5 Coder 32B (local)";
    };
    model = "ollama/qwen2.5-coder:32b";
  });

  sshConfig = pkgs.writeText "honeybee-ssh-config" ''
    Host github.com
      User git
      IdentityFile ${config.age.secrets.beehive-deploy-key.path}
      IdentitiesOnly yes
      StrictHostKeyChecking accept-new
  '';

  gitConfig = pkgs.writeText "honeybee-gitconfig" ''
    [user]
      name = honeybee
      email = honeybee@green
  '';
in
{
  imports = [
    # beehive's flake wraps nixosModules per-system (a flake-utils quirk), so
    # there's no top-level nixosModules.default — index by system first.
    # (Referencing `pkgs.system` here instead of the literal string causes
    # infinite recursion, since `pkgs` isn't resolvable while `imports` is
    # still being evaluated.)
    inputs.beehive.nixosModules.x86_64-linux.default
  ];

  # Shared across all beehive/honeybee hosts (see roles/beehived.nix) so
  # scaling to more machines doesn't require minting a new deploy key.
  age.secrets.beehive-deploy-key = {
    file = ../secrets/beehive-deploy-key.age;
    owner = "honeybee";
    group = "honeybee";
  };

  users.users.honeybee = {
    isSystemUser = true;
    group = "honeybee";
    home = "/var/lib/honeybee";
    createHome = true;
  };
  users.groups.honeybee = { };

  systemd.tmpfiles.rules = [
    "d /var/lib/honeybee/.config/beehive 0750 honeybee honeybee -"
    "L+ /var/lib/honeybee/.config/beehive/config.yaml - - - - ${configYaml}"
    "d /var/lib/honeybee/.config/opencode 0750 honeybee honeybee -"
    "L+ /var/lib/honeybee/.config/opencode/opencode.json - - - - ${opencodeJson}"
    "d /var/lib/honeybee/.ssh 0700 honeybee honeybee -"
    "L+ /var/lib/honeybee/.ssh/config - - - - ${sshConfig}"
    "L+ /var/lib/honeybee/.gitconfig - - - - ${gitConfig}"
  ];

  # Clones and scaffolds the beehive-infra repo on first activation (repoRoot
  # is otherwise empty/unscaffolded and honeybee has nothing to work on — it
  # needs AGENTS.md etc., which only `beehive init` writes); a no-op
  # afterwards (init is idempotent, and re-committing is a no-op once nothing
  # changed).
  systemd.services.honeybee-repo-init = {
    description = "Clone + scaffold the beehive-infra repo for honeybee";
    before = [ "honeybee.service" ];
    requiredBy = [ "honeybee.service" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    # bash is needed because `beehive init`-installed git hooks have a
    # `#!/usr/bin/env sh` shebang, and git invokes them during commit.
    path = [ pkgs.git pkgs.openssh pkgs.bash pkgs.gnupg ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "honeybee";
      Group = "honeybee";
    };
    script = ''
      set -eu
      if [ ! -d /var/lib/honeybee/beehive-infra/.git ]; then
        git clone git@github.com:graysonhead/beehive-infra.git /var/lib/honeybee/beehive-infra
      fi
      ${inputs.beehive.packages.x86_64-linux.beehive}/bin/beehive init /var/lib/honeybee/beehive-infra
      # See roles/beehived.nix for why this runs on every activation.
      ${inputs.beehive.packages.x86_64-linux.beehive}/bin/beehive instruction update --repo /var/lib/honeybee/beehive-infra
      git -C /var/lib/honeybee/beehive-infra fetch -q origin || true
      git -C /var/lib/honeybee/beehive-infra add -A
      if ! git -C /var/lib/honeybee/beehive-infra diff --cached --quiet; then
        git -C /var/lib/honeybee/beehive-infra commit -q -m "beehive init"
      fi
      git -C /var/lib/honeybee/beehive-infra pull --rebase -q origin main || true
      git -C /var/lib/honeybee/beehive-infra push -q origin HEAD:main || true
    '';
  };

  services.beehived.honeybee = {
    enable = true;
    repoRoot = "/var/lib/honeybee/beehive-infra";
    schedule = "*:0/1"; # every minute; adjust if you want a different cadence
    requireNoLoggedInUsers = true; # skip runs while you're actively using green
  };

  systemd.services.honeybee = {
    after = [ "honeybee-repo-init.service" ];
    path = [ pkgs.opencode pkgs.openssh ]; # merges with the module's own [ git gnupg bash ]
    serviceConfig = {
      User = "honeybee";
      Group = "honeybee";
    };
  };
}
