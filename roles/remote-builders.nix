{ config, pkgs, lib, ... }:

{

  nix.buildMachines = [
    {
      hostName = "blue.i.graysonhead.net";
      sshUser = "grayson";
      sshKey = "/home/grayson/.ssh/id_ed25519";
      system = "x86_64-linux";
      maxJobs = 4;
      speedFactor = 3;
      supportedFeatures = [ "nixos-test" "benchmark" "kvm" ];
    }
    {
      hostName = "green.i.graysonhead.net";
      sshUser = "grayson";
      sshKey = "/home/grayson/.ssh/id_ed25519";
      system = "x86_64-linux";
      maxJobs = 8;
      speedFactor = 4;
      supportedFeatures = [ "nixos-test" "benchmark" "kvm" ];
    }
  ];
  nix.distributedBuilds = true;
  #   lib.mkIf (config.specialisation != { }) {
  #   nix.distributedBuilds = true;
  # };
  # specialisation = {
  #   localbuilds.configuration = {
  #     nix.distributedBuilds = false;
  #   };
  # };
}
