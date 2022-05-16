let
    grayson = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcK4UDJD8r5r7XRjWJIT6SLlIOqD5TCHc2zCarEDre0 grayson@graysonhead.net";
    users = [ grayson ];
    ops = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIesZVAoa5QkmDQ95sOrOhLHao8Pi1ZUxEyr+Uh5Gfnr";
    systems = [ ops ];
in
{
    "digitalocean-key.age".publicKeys = users ++ systems;
}