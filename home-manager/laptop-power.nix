{ lib, ... }:
# Forces suspend-then-hibernate (rather than plain suspend) on AC and when the
# battery is low, for every home-manager user on this system. The actual
# hibernate delay is a system-wide setting (systemd.sleep.settings.Sleep in
# roles/laptop.nix), not per-user.
{
  home-manager.sharedModules = [
    {
      programs.plasma.enable = lib.mkDefault true;
      programs.plasma.powerdevil = {
        AC.whenSleepingEnter = "standbyThenHibernate";
        lowBattery.whenSleepingEnter = "standbyThenHibernate";
      };
    }
  ];
}
