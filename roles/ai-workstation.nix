{ nixpkgs, pkgs, lib, config, ... }:

{
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
  ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    # Kept outside services.ollama.home (/var/lib/ollama, systemd's
    # DynamicUser StateDirectory) -- see comment below for why.
    models = "/var/lib/ollama-models";
  };

  # ollama runs under systemd's DynamicUser, which picks a new random UID on
  # every service start. Directories under StateDirectory= (i.e. inside
  # services.ollama.home) are recursively re-chowned to that fresh UID/GID by
  # systemd on every single start -- confirmed by chgrp-ing the old models
  # dir to a stable group and watching a restart silently revert it. That
  # makes any group-based permission trick on that tree pointless.
  #
  # Fix: keep the models directory entirely outside the StateDirectory tree,
  # as a plain host directory systemd never touches. Ownership is a stable
  # group instead of a UID: setgid + group-writable, with ollama joined to
  # that group as a supplementary group (unaffected by DynamicUser's UID
  # churn) and a umask that keeps new files group-writable.
  users.groups.ollama-models = { };

  systemd.services.ollama.serviceConfig = {
    SupplementaryGroups = [ "ollama-models" ];
    UMask = lib.mkForce "0007";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/ollama-models 2770 root ollama-models -"
  ];

  # Environment variables for AMD acceleration
  environment.variables = {
    HSA_OVERRIDE_GFX_VERSION = "11.0.0"; # Adjust for your GPU
  };

  users.users.grayson.extraGroups = [ "render" "ollama-models" ];
}
