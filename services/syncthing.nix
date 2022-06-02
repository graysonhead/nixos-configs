{ nixpkgs, ... }: {

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "grayson";
    configDir = "/home/grayson/.config/syncthing";
  };
}
