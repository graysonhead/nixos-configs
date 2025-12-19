{ pkgs, ... }:
let
  defaultIconFileName = "w.icon";
  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/icons/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = { fileName = defaultIconFileName; };
  };
in
{
  home.stateVersion = "21.11";
  home.packages = with pkgs; [
    celestia
    krita
    tuxtype
    tuxpaint
    superTuxKart
    superTux
    zip
    vlc
    (unstable.discord.override { nss = pkgs.nss_latest; })
    steam
  ];
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
