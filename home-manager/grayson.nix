{ pkgs, deploy-rs, agenix, ... }: 
# Home manager module for full desktop installs
{
	programs.vscode = {
		enable = true;
		package = pkgs.vscode;
        extensions = with pkgs.vscode-extensions; [
            bbenoist.nix
			bungcip.better-toml
			formulahendry.code-runner
			golang.go
			ms-python.python
			matklad.rust-analyzer
        ];
	};
	home.packages = with pkgs; [
		cargo
		rustc
		rustfmt
		opera
		discord
		joplin-desktop
		gcc
		redis
		deploy-rs.defaultPackage.x86_64-linux
		transmission-qt
		wireshark
		agenix.defaultPackage.x86_64-linux
	];

	programs.home-manager = {
		enable = true;
	};

	services.kdeconnect = {
		enable = true;
		indicator = true;
	};
}
