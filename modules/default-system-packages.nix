{ pkgs, ... }: {
    environment = {
        systemPackages = with pkgs; [
            git
            wget
            curl
            bind
            tcpdump
        ];
    };
}