{ nixpkgs, pkgs, inputs, lib, config, ... }:

{
  config.environment.systemPackages = with pkgs; [ restic ];
  config.age.secrets.restic = {
    file = ../secrets/backblaze_restic.age;
    group = "wheel";
    mode = "0440";
  };
  config.age.secrets.restic_password = {
    file = ../secrets/restic_password.age;
    group = "wheel";
    mode = "0440";
  };
  config.services.restic.backups = {
    home = {
      repository = "b2:nixos-backups";
      paths = [ "/home" ];
      initialize = true;
      timerConfig = {
        OnCalendar = "*-*-* 02:00:00";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 75"
      ];
      extraBackupArgs = [
        "--exclude=target/**"
        "--exclude=Downloads/**"
        "--exclude=Builds/**"
        "--exclude=keybase/**"
      ];
      environmentFile = config.age.secrets.restic.path;
      passwordFile = config.age.secrets.restic_password.path;
    };
  };
}
