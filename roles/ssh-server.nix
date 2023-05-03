{ nixpkgs, inputs, pkgs, config, ... }:
{
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
}
