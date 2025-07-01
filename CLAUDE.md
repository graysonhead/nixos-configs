# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS configurations repository using Nix flakes to manage multiple system configurations for various machines (desktop, laptop, servers). The repository follows a modular architecture with roles, modules, services, and systems.

## Architecture

- **flake.nix**: Main entry point defining all system configurations, inputs, and deployment targets
- **systems/**: Machine-specific configurations organized by hostname (blue, green, skippy, etc.)
- **roles/**: Reusable configuration roles (plasma-desktop, factorio-server, steam, etc.)
- **modules/**: Core system modules (common settings, package defaults, specific services)
- **home-manager/**: User-specific home manager configurations
- **services/**: Custom systemd services and configurations
- **secrets/**: Age-encrypted secrets managed with agenix

## Common Commands

### Building and Testing
```bash
# Check flake configuration for errors (run this after any changes)
nix flake check

# Build a specific system configuration
nix build .#nixosConfigurations.HOSTNAME.config.system.build.toplevel

# Test configuration without switching
sudo nixos-rebuild test --flake .#HOSTNAME

# Switch to new configuration
sudo nixos-rebuild switch --flake .#HOSTNAME

# Build and test locally (for the current machine)
sudo nixos-rebuild switch --flake .
```

### Development Environment
```bash
# Enter development shell with agenix, deploy-rs, and nixpkgs-fmt
nix develop

# Format Nix files
nixpkgs-fmt **/*.nix
```

### Deployment
```bash
# Deploy to remote systems using deploy-rs
deploy .#blue
deploy .#bounce-ksfo

# Deploy all configured nodes
deploy
```

Sometimes Services (especially docker based ones) can fail on rebuild, so sometimes it is necessary to push deployments without auto rollback (--auto-rollback) or magic rollback (--magic-rollback). It is important not to disable these when making network changes as you might lose connection to the remote system.

### Secrets Management
```bash
# Edit encrypted secrets (requires agenix)
agenix -e secrets/SECRET_NAME.age

# Re-key all secrets after changing keys
agenix -r
```

## Key System Configurations

- **blue**: Main server (factorio, photoprism, ssh, libvirt)
- **green**: Main Desktop (plasma, gaming, VR, ML notebook)
- **skippy**: Framework laptop (plasma, portable setup)
- **bounce-ksfo**: VPN bounce node

## Development Patterns

### Adding New Systems
1. Create directory in `systems/NEW_HOSTNAME/`
2. Add `configuration.nix` and `hardware-configuration.nix`
3. Add system to `nixosConfigurations` in `flake.nix`
4. Import appropriate roles for the system's purpose

### Creating New Roles
1. Create new file in `roles/ROLE_NAME.nix`
2. Import required modules and define specific packages/services
3. Test role by adding to a system configuration

### Managing Secrets
1. All secrets are encrypted with agenix and stored in `secrets/`
2. Add new secrets to `secrets/secrets.nix` with appropriate access permissions
3. Reference secrets in configurations using the agenix module pattern

## Home Manager Integration

User configurations are managed through home-manager with modular setups:
- `full-homes.nix`: Complete desktop environments
- `minimal-homes.nix`: Minimal server/headless setups
- Individual user files: `grayson.nix`, `maerose.nix`, etc.

## Special Notes

- Uses unstable packages overlay for newer software versions
- Plasma 6 desktop environment with custom KDE configurations  
- Secrets are managed with agenix encryption
- Remote deployment handled by deploy-rs
- Custom DNS and networking configurations for internal services
