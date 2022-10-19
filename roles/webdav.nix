{ nixpkgs, inputs, config, ... }:
{
    services.webdav-server-rs = {
        enable = true;
        settings = {
            server.listen = [ "0.0.0.0:4918" "[::]:4918" ];
            accounts = {
                auth-type = "pam";
                acct-type = "unix";
            };
            pam = {
                service = "other";
                cache-timeout = 128;
                threads = 4;
            };
            location = [
                {
                    route = ["/home/*path"];
                    directory = "~";
                    handler = "filesystem";
                    methods = [ "webdav-rw" ];
                    autoindex = true;
                    auth = "true";
                    setuid = true;
                }
            ];
        };
    };
    networking.firewall.allowedTCPPorts = [ 
        4918
    ];
}