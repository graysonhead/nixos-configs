{ nixpkgs, pkgs, inputs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    (blender.override { cudaSupport = true; })
    imagemagick
    unstable.godot_4
    unityhub
  ];
}
