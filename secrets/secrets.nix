let
    grayson = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcK4UDJD8r5r7XRjWJIT6SLlIOqD5TCHc2zCarEDre0 grayson@graysonhead.net";
    users = [ grayson ];
    ops = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIesZVAoa5QkmDQ95sOrOhLHao8Pi1ZUxEyr+Uh5Gfnr";
    nx1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEo7WqbCAS2y8zlxnFFNKsiJkGTXRpesiRIm8g8G2io1";
    factorio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINa0kSfUH79cdUbgC7Tj8bJXLNsNrLiwmtrjnjyeoAP7";
    systems = [ ops nx1 factorio ];
in
{
    "digitalocean-key.age".publicKeys = users ++ systems;
}