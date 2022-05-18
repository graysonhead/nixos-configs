{ pkgs, inputs, ... }: 
# Enable nix flakes, set default systempackages, disable package signing for deploy-rs
{
    imports = [
        ./dns-agent.nix
    ];
    nix.requireSignedBinaryCaches = false;
    nixpkgs.config.allowUnfree = true;
    environment = {
        systemPackages = with pkgs; [
            git
            wget
            curl
            bind
            tcpdump
        ];
    };

    nix = {
        package = pkgs.nixFlakes;
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };
}
