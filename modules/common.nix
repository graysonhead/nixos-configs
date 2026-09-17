{ pkgs, inputs, ... }:
# Enable nix flakes, set default systempackages, disable package signing for deploy-rs
{
  imports = [
    inputs.dns-agent.nixosModules.x86_64-linux.dns-agent
    ./default-system-packages.nix
    ./nix-gc.nix
  ];
  nix.settings = {
    require-sigs = false;
    trusted-users = [ "grayson" "root" ];
    trusted-substituters = [
      "ssh://green.i.graysonhead.net"
      "ssh://blue.i.graysonhead.net"
      "https://simula.cachix.org"
    ];
  };
  # crates.io blocks the default curl user-agent used by nixpkgs' fetchurl
  # builder for fixed-output derivations (e.g. Cargo.lock crate downloads),
  # returning 403. A descriptive user-agent avoids the block.
  systemd.services.nix-daemon.environment.NIX_CURL_FLAGS = "--user-agent graysonhead-nixos-configs-nix-fetch/1.0";
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;
  environment = {
    systemPackages = with pkgs; [
      git
      wget
      curl
      bind
      tcpdump
      killall
      efibootmgr
      usbutils
      dmidecode
      iperf
    ];
  };
  networking.search = [
    "i.graysonhead.net"
    "graysonhead.net"
  ];
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
