{ inputs, config, pkgs, ... }:

let
  sshConfig = pkgs.writeText "beehive-ssh-config" ''
    Host github.com
      User git
      IdentityFile ${config.age.secrets.beehive-deploy-key.path}
      IdentitiesOnly yes
      StrictHostKeyChecking accept-new
  '';

  gitConfig = pkgs.writeText "beehive-gitconfig" ''
    [user]
      name = beehived
      email = beehive@blue.i.graysonhead.net
  '';

  # No model/agent_url yet (webui chat/editor backend is still deferred) —
  # this just satisfies beehived's own bootstrap "runner config" check, which
  # only tests for the file's existence.
  configYaml = pkgs.writeText "beehive-config.yaml" ''
    agent_cmd: opencode
    ttl_minutes: 60
    max_turns: 15
    reject_limit: 3
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

  # Shared across all beehive/honeybee hosts (see roles/beehive-honeybee.nix)
  # so scaling to more machines doesn't require minting a new deploy key.
  age.secrets.beehive-deploy-key = {
    file = ../secrets/beehive-deploy-key.age;
    owner = "beehive";
    group = "beehive";
  };

  users.users.beehive = {
    isSystemUser = true;
    group = "beehive";
    home = "/var/lib/beehive";
    createHome = true;
  };
  users.groups.beehive = { };

  systemd.tmpfiles.rules = [
    "d /var/lib/beehive-infra 0750 beehive beehive -"
    "d /var/lib/beehive/.ssh 0700 beehive beehive -"
    "L+ /var/lib/beehive/.ssh/config - - - - ${sshConfig}"
    "L+ /var/lib/beehive/.gitconfig - - - - ${gitConfig}"
    "d /var/lib/beehive/.config/beehive 0750 beehive beehive -"
    "L+ /var/lib/beehive/.config/beehive/config.yaml - - - - ${configYaml}"
  ];

  # Clones and scaffolds the beehive-infra repo on first boot (repoRoot is
  # otherwise empty/unscaffolded and beehived refuses to start — it needs
  # AGENTS.md etc., which only `beehive init` writes); a no-op afterwards
  # (init is idempotent, and re-committing is a no-op once nothing changed).
  systemd.services.beehived-repo-init = {
    description = "Clone + scaffold the beehive-infra repo for beehived";
    before = [ "beehived.service" ];
    requiredBy = [ "beehived.service" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    # bash is needed because `beehive init`-installed git hooks have a
    # `#!/usr/bin/env sh` shebang, and git invokes them during commit.
    path = [ pkgs.git pkgs.openssh pkgs.bash pkgs.gnupg ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "beehive";
      Group = "beehive";
    };
    script = ''
      set -eu
      if [ ! -d /var/lib/beehive-infra/.git ]; then
        git clone git@github.com:graysonhead/beehive-infra.git /var/lib/beehive-infra
      fi
      ${inputs.beehive.packages.x86_64-linux.beehive}/bin/beehive init /var/lib/beehive-infra
      # Keeps the managed prompts (AGENTS.md/HONEYBEE.md/BOOTSTRAP.md) in sync
      # with the binary on every activation — otherwise bumping the `beehive`
      # flake input updates the binaries but leaves stale prompts in place
      # indefinitely (docs/bootstrap_guide.md calls this "Axis B"). Never
      # touches LOCALS.md or anything under submodules/. Non-interactive, so
      # a file we've hand-modified is safely left alone rather than clobbered.
      ${inputs.beehive.packages.x86_64-linux.beehive}/bin/beehive instruction update --repo /var/lib/beehive-infra
      git -C /var/lib/beehive-infra fetch -q origin || true
      git -C /var/lib/beehive-infra add -A
      if ! git -C /var/lib/beehive-infra diff --cached --quiet; then
        git -C /var/lib/beehive-infra commit -q -m "beehive init"
      fi
      git -C /var/lib/beehive-infra pull --rebase -q origin main || true
      git -C /var/lib/beehive-infra push -q origin HEAD:main || true
    '';
  };

  services.beehived = {
    enable = true;
    repoRoot = "/var/lib/beehive-infra";
    listenAddress = "127.0.0.1:8955";
  };

  systemd.services.beehived = {
    after = [ "beehived-repo-init.service" ];
    # openssh: beehived shells out to `git fetch`/`push` over SSH while
    # serving requests (e.g. viewing a file), but the upstream module's own
    # `path` for this unit only has git/gnupg/bash.
    path = [ pkgs.openssh ];
    serviceConfig = {
      User = "beehive";
      Group = "beehive";
    };
  };

  services.nginx.virtualHosts."beehive.i.graysonhead.net" = {
    useACMEHost = "beehive.i.graysonhead.net";
    forceSSL = true;
    extraConfig = ''
      allow 10.5.0.0/16;
      allow 2605:a601:a0a6:6c00::/64;
      deny all;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:8955";
      proxyWebsockets = true;
    };
  };
}
