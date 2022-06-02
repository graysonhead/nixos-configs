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
        OnCalendar = "daily";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 75"
      ];
      extraBackupArgs = [
        "--exclude=.*"
        "--exclude=target/**"
        "--exclude=Downloads/**"
        "--exclude=Builds/**"
      ];
      environmentFile = config.age.secrets.restic.path;
      passwordFile = config.age.secrets.restic_password.path;
    };
  };
}
