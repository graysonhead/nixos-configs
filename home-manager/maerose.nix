{ pkgs, ... }: {
  home.stateVersion = "21.11";
  home.packages = with pkgs; [
    unstable.google-chrome
    unstable.firefox
    zip
    vlc
    (unstable.discord.override { nss = pkgs.nss_latest; })
  ];
  programs.bash = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild boot --flake github:graysonhead/nixos-configs && sudo shutdown -r now";
      exportall = "f(){ set -o allexport; source $1; set +o allexport; }; f";
      nixrestic = "f(){ exportall /run/agenix/restic; restic -r b2:nixos-backups -p /run/agenix/restic_password $@; }; f";
    };
  };
}
