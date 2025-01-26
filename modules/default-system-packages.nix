{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment = {
    systemPackages = with pkgs; [
      git
      wget
      curl
      bind
      tcpdump
      zip
      unzip
      unrar
      libtelnet
      openssl
    ];
  };
}
