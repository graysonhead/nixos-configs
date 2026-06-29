{ nixpkgs, inputs, pkgs, config, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    localNetworkGameTransfers.openFirewall = true;
    extest.enable = true; # Better input handling for streaming
    package = pkgs.steam.override { extraArgs = "-pipewire"; };
  };

  # Ensure VA-API is available for hardware encoding with AMD GPU
  hardware.graphics.extraPackages = with pkgs; [
    libva
    libva-utils
  ];

}
