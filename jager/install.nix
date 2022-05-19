{ config, pkgs, inputs, ...}:
{
    environment.systemPackages = with pkgs; [
        inputs.jager.packages.${system}.jager-backend
    ];
}
