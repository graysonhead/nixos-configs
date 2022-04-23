{ pkgs, ... }: {
    environment = {
        systemPackages = with pkgs; [
            git
            wgetcurl
            bind
            tcpdump
        ];
    };
}