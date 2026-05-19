{ ... }:

{
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000f", MODE="0660", GROUP="plugdev", TAG+="uaccess"
  '';
}
