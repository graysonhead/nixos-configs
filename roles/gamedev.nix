{ nixpkgs, pkgs, inputs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    # (blender.override { cudaSupport = true; })
    blender
    imagemagick
    unstable.godot_4
  ];
}
