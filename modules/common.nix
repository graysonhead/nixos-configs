{ pkgs, inputs, ... }:
# Enable nix flakes, set default systempackages, disable package signing for deploy-rs
{
  imports = [
    ./dns-agent.nix
    ./default-system-packages.nix
  ];
  programs.vim.defaultEditor = true;
  nix.requireSignedBinaryCaches = false;
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
    "graysonhead.net" 
    "flightaware.com" 
    "hou.flightaware.com" 
    "dal.flightaware.com"
  ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
