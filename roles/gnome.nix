{ nixpkgs, inputs, pkgs, config, ... }:
{
  imports = [ ../modules/common.nix ];
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
