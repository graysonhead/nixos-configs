{ pkgs, ... }: {
	imports = [./grayson-minimal.nix];
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
	];
	services.syncthing = {
		enable = true;
		tray.enable = true;
	};

	programs.home-manager = {
		enable = true;
	};
}
