{ pkgs, ... }:
let
  defaultIconFileName = "m.icon";
  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/icons/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = { fileName = defaultIconFileName; };
  };
  sharedCalendars = import ./shared-calendars.nix { lib = pkgs.lib; };
in
{
  home.stateVersion = "21.11";

  programs.thunderbird = {
    enable = true;
    profiles."default" = {
      isDefault = true;
      settings = sharedCalendars.sharedCalendars { use24HourFormat = false; };
    };
  };
  home.packages = with pkgs; [
    google-chrome
    firefox
    zip
    vlc
    (unstable.discord.override { nss = pkgs.nss_latest; })
    steam
  ];
  programs.bash = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild boot --flake github:graysonhead/nixos-configs && sudo shutdown -r now";
      exportall = "f(){ set -o allexport; source $1; set +o allexport; }; f";
      nixrestic = "f(){ exportall /run/agenix/restic; restic -r b2:nixos-backups -p /run/agenix/restic_password $@; }; f";
    };
  };
  home.file = {
    ".face.icon" = {
      source = defaultIcon;
    };
  };
  home.activation = {
    text = ''
      chmod a+x ~
      setfacl -m u:sddm:x ~
    '';
  };
}
