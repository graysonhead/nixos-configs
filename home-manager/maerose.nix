{ pkgs, ... }: {
  home.stateVersion = "21.11";
  home.packages = with pkgs; [
    google-chrome
    zip
    vlc
    (unstable.discord.override { nss = pkgs.nss_latest; })
  ];
  programs.bash = {
    enable = true;
    shellAliases = {
      update = "sudo nix-collect-garbage && sudo nixos-rebuild switch --flake github:graysonhead/nixos-configs";
      exportall = "f(){ set -o allexport; source $1; set +o allexport; }; f";
      nixrestic = "f(){ exportall /run/agenix/restic; restic -r b2:nixos-backups -p /run/agenix/restic_password $@; }; f";
    };
  };
}
