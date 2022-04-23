{ nixpkgs, ... }:

{
    users.users.grayson = {
        isNormalUser = true;
        home = "/home/grayson";
        description = "Grayson Head";
        extraGroups = [ "wheel" "networkmanager" ];
    };
}