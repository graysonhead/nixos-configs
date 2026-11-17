{ pkgs, inputs, ... }:

# Claude Desktop from aaddrick/claude-desktop-debian, which repackages
# Anthropic's official Linux .deb. The FHS variant lets MCP servers launched
# via npx/uvx/docker work on NixOS.
{
  nixpkgs.overlays = [ inputs.claude-desktop.overlays.default ];
  environment.systemPackages = [ pkgs.claude-desktop-fhs ];
}
