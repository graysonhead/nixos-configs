{ pkgs, ... }: {
  home.packages = with pkgs; [
    google-chrome
    zip
    vlc
  ];
}
