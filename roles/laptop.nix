{ nixpkgs, inputs, pkgs, config, ... }:
{
  # Allow the active user to suspend/hibernate even when multiple users are logged in.
  # By default, logind requires admin auth for the *-multiple-sessions polkit actions.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      var sleepActions = [
        "org.freedesktop.login1.suspend-multiple-sessions",
        "org.freedesktop.login1.hibernate-multiple-sessions",
        "org.freedesktop.login1.hybrid-sleep-multiple-sessions",
        "org.freedesktop.login1.suspend-then-hibernate-multiple-sessions"
      ];
      if (sleepActions.indexOf(action.id) !== -1 && subject.active) {
        return polkit.Result.YES;
      }
    });
  '';

  powerManagement.powertop.enable = true;
  environment.systemPackages = with pkgs; [
    powertop
    lldpd
  ];
  services.lldpd.enable = true;
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes";
    AllowHibernation = "yes";
    AllowHybridSleep = "yes";
    AllowSuspendThenHibernate = "yes";
    HibernateDelaySec = "3600";
  };
}
