{ pkgs, inputs, ... }:
# Enable nix flakes, set default systempackages, disable package signing for deploy-rs
{
  imports = [
    ./dns-agent.nix
    ./default-system-packages.nix
    ./nix-gc.nix
  ];
  programs.vim.defaultEditor = true;
  nix.settings = {
    require-sigs = false;
    trusted-users = [ "grayson" "root" ];
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
    ];
  };
  networking.search = [
    "i.graysonhead.net"
    "flightaware.com"
  ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
  };
}
