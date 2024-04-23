{ nixpkgs, inputs, pkgs, config, ... }:
let
  overlay = final: prev: {
    xr-hardware = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.xr-hardware;
  };
in
{
  nixpkgs.overlays = [ overlay ];
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/hardware/monado.nix"
  ];
  services.monado = {
    enable = true;
    # package = pkgs.monado.overrideAttrs
    #   (old: {
    #     src = pkgs.fetchFromGitLab {
    #       domain = "gitlab.freedesktop.org";
    #       owner = "monado";
    #       repo = "monado";
    #       rev = "39fb50bfcfffde8aa7948e1dfaa3e2d66f8a46d0";
    #       hash = "sha256-wXRwOs9MkDre/VeW686DzmvKjX0qCSS13MILbYQD6OY=";
    #     };
    #     patches = [ ];
    #   });
    # highPriority = true;
    # defaultRuntime = true;
  };
}
