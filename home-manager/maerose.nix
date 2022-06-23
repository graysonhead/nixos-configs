{ pkgs, ... }: {
  home.stateVersion = "21.11";
  home.packages = with pkgs; [
    google-chrome
    zip
    vlc
  ];
  programs.bash = {
    enable = true;
    shellAliases = {
      update = "sudo nix-collect-garbage && sudo nixos-rebuild switch --flake github:graysonhead/nixos-configs";
    };
  };
}
