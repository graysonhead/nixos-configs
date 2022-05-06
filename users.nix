
{ nixpkgs, home-manager, ... }:
# Contains user entries for all users as well as default minimal home manager module imports
{
    security.sudo.wheelNeedsPassword = false;
    users.users.grayson = {
        isNormalUser = true;
        uid = 1001;
        home = "/home/grayson";
        description = "Grayson Head";
        extraGroups = [ "wheel" "networkmanager" ];
        openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDUwklAO/d0TPbgfuHDI4gNf65UdApgzWcVL1/SbBJUnnHmFRc1dGMIJk29I/7WAbWe7uqHdyJYsAQw7IhPjK1LcTrzBZfq3gm94+z8YBZLb1BImZfb9LrRjgGLnKzGO1qCwNKZPsxRs3rOYt/0d7Z6+AZqLBoR1KQR0fLuo1SapTxZukhqRGRn3NiDTG7DWImbFSz835bjuPKxy6OnNv1DI7OY9YCPpLjR6gV7j+wU6tzlrN7+yP2rJUd+YzA50Ib/UGcm7XTTKv1TyARE64tRSp5THq7CSiJcscQUtA7QdQdxKbdsajrMHOjFDb0kRyLoVOlRct1RwtvY5AYB3mbMtFFF0xiAbjKsLzSg4XGux+c/mjItFFD6HSGUf7+1aI+Wbj25MGpuU5/Gld6cKzRY9H01BdqxPzHHs5KcBRYf/9w8bd/gj1+oxA/UAcKXSx91NKeJxQTGYkdlO5cJCrL/MzedCuQbzrQ83iq+WInOHVfB0Ylta0znSZoUyjJhDM= grayson@gdesktop.i.graysonhead.net"];
    };
    home-manager.users.grayson = import ./home-manager/grayson-minimal.nix;

    users.users.maerose = {
        isNormalUser = true;
        uid = 1002;
        home = "/home/maerose";
        description = "Maerose Head";
        extraGroups = [ "networkmanager" ];
    };
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
}
