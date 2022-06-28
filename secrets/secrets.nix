let
  grayson = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcK4UDJD8r5r7XRjWJIT6SLlIOqD5TCHc2zCarEDre0 grayson@graysonhead.net";
  users = [ grayson ];
  ops = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIesZVAoa5QkmDQ95sOrOhLHao8Pi1ZUxEyr+Uh5Gfnr";
  nx1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEo7WqbCAS2y8zlxnFFNKsiJkGTXRpesiRIm8g8G2io1";
  factorio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINa0kSfUH79cdUbgC7Tj8bJXLNsNrLiwmtrjnjyeoAP7";
  deckchair = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFbxjqdNMawqU4C99V0OqyMVFxZCUypUQn6mTLErg6Yi";
  notanipad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDc6PTFN/6mi/eY5lAl3IzdBFhl6ppUYZcJpUrTwEN8P";
  mombox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2POjia3nzKq4rWfndaxKPc7/6G8a+OLSmgOKBL+twp";
  green = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCbroGDeBk7doFoaqXfVAelQWErvn6ewdszLQQSuU28";
  systems = [ ops nx1 factorio deckchair notanipad mombox green ];
in
{
  "digitalocean-key.age".publicKeys = users ++ systems;
  "factorio.age".publicKeys = users ++ [ factorio ];
  "factorio-bot.age".publicKeys = users ++ [ factorio ];
  "backblaze_restic.age".publicKeys = users ++ systems;
  "restic_password.age".publicKeys = users ++ systems;
}

