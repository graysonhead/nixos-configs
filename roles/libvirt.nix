{ nixpkgs, inputs, pkgs, config, ... }:
{
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  environment.systemPackages = with pkgs; [
    virtiofsd
  ];
}
