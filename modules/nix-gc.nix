{ pkgs, ... }:
let
  nix-store-cleanup = pkgs.writeShellScriptBin "nix-store-cleanup" ''
    if [ "$(id -u)" -ne 0 ]; then
      echo "nix-store-cleanup must be run as root" >&2
      exit 1
    fi

    for profile in /home/*/.local/state/nix/profiles/home-manager; do
      [ -e "$profile" ] || continue
      user=$(echo "$profile" | cut -d'/' -f3)
      echo "Cleaning old home-manager generations for $user (keeping last 3)..."
      nix-env --delete-generations +3 -p "$profile"
    done

    if [ -e /root/.local/state/nix/profiles/home-manager ]; then
      echo "Cleaning old home-manager generations for root (keeping last 3)..."
      nix-env --delete-generations +3 -p /root/.local/state/nix/profiles/home-manager
    fi

    echo "Running nix-collect-garbage -d..."
    nix-collect-garbage -d
  '';
in
{
  nix.gc = {
    automatic = true;
    dates = "03:15";
    options = "--delete-older-than 30d";
  };

  environment.systemPackages = [ nix-store-cleanup ];
}
