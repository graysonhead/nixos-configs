home-manager.users.grayson = { pkgs, ...}: {
    home.packages = with pkgs; [
        tcpdump
        git
        vim
    ];
    programs.bash.enable = true;

    programs.git = {
        enable = true;
        userName = "Grayson Head";
        userEmail = "grayson@graysonhead.net";
        extraConfig = {
            github.user = "graysonhead";
        };
    };

    home.packages = with pkgs; [
        git-fame
    ];
}