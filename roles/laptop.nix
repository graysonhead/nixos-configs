{ nixpkgs, inputs, pkgs, config, ... }:
{
  powerManagement.powertop.enable = true;
  environment.systemPackages = with pkgs; [
    powertop
    lldpd
  ];
  services.lldpd.enable = true;
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
    HibernateDelaySec=1500
  '';
}
