{ pkgs, inputs, ... }:
# Enable nix flakes, set default systempackages, disable package signing for deploy-rs
{
  imports = [
    inputs.dns-agent.nixosModules.x86_64-linux.dns-agent
    ./default-system-packages.nix
    ./nix-gc.nix
  ];
  programs.vim.defaultEditor = true;
  nix.settings = {
    require-sigs = false;
    trusted-users = [ "grayson" "root" ];
    trusted-substituters = [
      "ssh://green.i.graysonhead.net"
      "ssh://blue.i.graysonhead.net"
      "https://simula.cachix.org"
    ];
  };
  nixpkgs.config.allowUnfree = true;
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
    ];
  };
  networking.search = [
    "i.graysonhead.net"
    "graysonhead.net"
  ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
  };
}
