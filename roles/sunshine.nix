{ ... }:

{
  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true;
    capSysAdmin = true; # Required for DRM/KMS capture on Wayland
  };

  # Required for Sunshine to inject keyboard/mouse input from Moonlight clients
  hardware.uinput.enable = true;
  users.users.grayson.extraGroups = [ "uinput" ];
}
