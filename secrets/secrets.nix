let
  grayson = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcK4UDJD8r5r7XRjWJIT6SLlIOqD5TCHc2zCarEDre0 grayson@graysonhead.net";
  users = [ grayson ];
  ops = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIesZVAoa5QkmDQ95sOrOhLHao8Pi1ZUxEyr+Uh5Gfnr";
  nx1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEo7WqbCAS2y8zlxnFFNKsiJkGTXRpesiRIm8g8G2io1";
  factorio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINa0kSfUH79cdUbgC7Tj8bJXLNsNrLiwmtrjnjyeoAP7";
  deckchair = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFbxjqdNMawqU4C99V0OqyMVFxZCUypUQn6mTLErg6Yi";
  notanipad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ1t9uF4tvZ7pZtMBQUkJKz6pP58pgChzKCRn/twfLsr";
  mombox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2POjia3nzKq4rWfndaxKPc7/6G8a+OLSmgOKBL+twp";
  green = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1WTvOABaXAllVH7vq0bOkKbEuKZ6FKXNYDwJMSJ7Kw";
  blue = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/+eOT7BTvdV2SgWeObYOEuAMrLiMHFg21VzXX8Wlku";
  chromebook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYaZ5RV6vfa1wiWaFFC1pgspnzcvIb6yfnBhhVNe4U4";
  bounce-ksfo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1xVQxbyh553AkA/O+tg5lu4jkb4eb1jjZyBeV1Oe0M";
  skippy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBP/ob24tap0AzKunuGtUrSkPkfmXzas4KhKy+wNT2OD root@skippy";
  hal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILs6qDibFnyVTiS9vY/rfWXSXXGE2oaT9ufo/tJan3BJ";
  systems = [ ops nx1 factorio deckchair notanipad mombox green blue chromebook bounce-ksfo skippy hal ];
in
{
  "digitalocean-key.age".publicKeys = users ++ systems;
  "cloudflare-dns.age".publicKeys = users ++ systems;
  "factorio.age".publicKeys = users ++ systems;
  "factorio-bot.age".publicKeys = users ++ systems;
  "factorio-rcon-password.age".publicKeys = users ++ systems;
  "backblaze_restic.age".publicKeys = users ++ systems;
  "restic_password.age".publicKeys = users ++ systems;
  "dns-acme.age".publicKeys = users ++ systems;
  "vaultwarden.age".publicKeys = users ++ [ blue ];
  "photoprism_admin_password.age".publicKeys = users ++ [ blue ];
  "bounce.graysonhead.net.key.age".publicKeys = users ++ [ bounce-ksfo ];
  "bounce.dh.pem.age".publicKeys = users ++ [ bounce-ksfo ];
  "bounce.graysonhead.net.crt.pem.age".publicKeys = users ++ systems;
  "graysonhead.net.crt.pem.age".publicKeys = users ++ systems;
  "fr24feed.age".publicKeys = users ++ systems;
}
