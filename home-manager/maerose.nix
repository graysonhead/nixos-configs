{ pkgs, ... }: {
    home.stateVersion = "21.11";
  home.packages = with pkgs; [
    google-chrome
    zip
    vlc
  ];
}
