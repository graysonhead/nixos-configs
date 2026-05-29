{ ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild boot --flake github:graysonhead/nixos-configs && flatpak update --assumeyes && sudo shutdown -r now";
      exportall = "f(){ set -o allexport; source $1; set +o allexport; }; f";
      nixrestic = "f(){ exportall /run/agenix/restic; restic -r b2:nixos-backups -p /run/agenix/restic_password $@; }; f";
    };
  };
}
