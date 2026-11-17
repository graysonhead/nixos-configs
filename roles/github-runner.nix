# Self-hosted GitHub Actions runners, one per repo.
#
# Personal accounts can't have account-wide runners (only orgs can), so each
# repo in `repos` below gets its own runner service (github-runner-<repo>).
# They all share one fine-grained PAT, which the module uses to mint fresh
# registration tokens on every start.
#
# The PAT (github.com/settings/personal-access-tokens) needs:
#   Repository access: the repos listed below
#   Permissions: Administration -> Read and write
# Store it with no trailing newline:
#   agenix -e secrets/github-runner-token.age
#
# Jobs run natively as an ephemeral DynamicUser under the module's hardened
# systemd unit, with nix on PATH (the module adds it). That is only a light sandbox, so only add
# repos you trust (not public repos that run workflows on fork PRs). Target it
# from a workflow with `runs-on: [self-hosted, nix]`.
{ config, pkgs, lib, ... }:
let
  owner = "graysonhead";
  repos = [
    "fieldfinder"
    "fin"
    "llmbot"
    "nixos-configs"
  ];

  # Headless browser for Claude to check its own web UI work. Workflows opt in
  # with `--mcp-config /etc/github-runner/claude-mcp.json` in claude_args and
  # `mcp__playwright__*` in --allowedTools. --no-sandbox because the runner
  # unit's RestrictNamespaces blocks Chromium's own sandbox. Screenshots go to
  # $RUNNER_TEMP so they never end up in the repo checkout.
  claudeMcpConfig = pkgs.writeText "claude-mcp.json" (builtins.toJSON {
    mcpServers.playwright = {
      command = "${pkgs.playwright-mcp}/bin/playwright-mcp";
      args = [ "--headless" "--isolated" "--no-sandbox" "--output-dir" "\${RUNNER_TEMP}/playwright" ];
    };
  });

  # Shown to Claude as managed-policy CLAUDE.md, but only inside the runner
  # units (bind-mounted below), not to interactive sessions on the host.
  claudeMd = pkgs.writeTextDir "CLAUDE.md" ''
    # Self-hosted runner (${config.networking.hostName})

    - If the workflow enabled the `playwright` MCP server, you have a headless
      Chromium. Use it to check web UI changes yourself: start the app's dev
      server in the background, open it on localhost, and take screenshots or
      snapshots to confirm the change looks and behaves right before you
      report back.
    - Screenshots are for your own verification. Don't commit them.
  '';
in
{
  age.secrets.github-runner-token.file = ../secrets/github-runner-token.age;

  environment.etc."github-runner/claude-mcp.json".source = claudeMcpConfig;
  # Empty mount point on the host for the runners' BindReadOnlyPaths.
  systemd.tmpfiles.rules = [ "d /etc/claude-code 0755 root root -" ];

  services.github-runners = lib.listToAttrs (map
    (repo: lib.nameValuePair repo {
      enable = true;
      url = "https://github.com/${owner}/${repo}";
      tokenFile = config.age.secrets.github-runner-token.path;
      name = "${config.networking.hostName}-${repo}";
      replace = true;
      # Fresh state dir and registration for every job, so nothing leaks
      # between runs.
      ephemeral = true;
      # The module only restarts on success, so a crash (e.g. the disk filling
      # mid-job) would leave the repo with no runner until restarted by hand.
      serviceOverrides = {
        Restart = lib.mkForce "always";
        RestartSec = "30s";
        BindReadOnlyPaths = [ "${claudeMd}:/etc/claude-code" ];
      };
      extraLabels = [ "nix" config.networking.hostName ];
      # nix, git, bash, coreutils, findutils, grep, sed, tar and gzip are
      # already included. unzip is needed by oven-sh/setup-bun (used by
      # claude-code-action); gh is used by Claude inside those jobs.
      extraPackages = with pkgs; [ cachix jq curl unzip xz gawk which gh ];
      extraEnvironment.NIX_CONFIG = "experimental-features = nix-command flakes";
    })
    repos);
}
