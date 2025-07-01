{ pkgs, ... }: {
  nix.gc = {
    automatic = true; # Enable the automatic garbage collector
    dates = "03:15"; # When to run the garbage collector
    options = "--delete-older-than 30d"; # Arguments to pass to nix-collect-garbage
  };
}
