{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "factorio";
  time.timeZone = "Chicago/America";
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  system.stateVersion = "21.11";
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" =
    {
      device = "/dev/vda1";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/vda2"; }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
