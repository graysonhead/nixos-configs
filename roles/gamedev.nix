{ nixpkgs, pkgs, inputs, lib, ... }:
{
    environment.systemPackages = with pkgs; [
      (unstable.blender.override { cudaSupport = true; })
      imagemagick
      unstable.godot
    ];
}