{ pkgs, ... }: {

	home.packages = with pkgs; [
		vim
		bind
		pciutils
		tmux
		htop
		nmon
		screen
	];
    programs.git = {
		package = pkgs.gitAndTools.gitFull;
		enable = true;
		userName = "Grayson Head";
		userEmail = "grayson@graysonhead.net";
	};
	programs.bash = {
		enable = true;
		shellAliases = {
			rebuild-from-dir = "nixos-rebuild build --impure --flake . && sudo ./result/bin/switch-to-configuration switch";
		};
	};
	home.file = {
		".tmux.conf" = {
			text = ''
                        setw -g mouse on
                        '';
		};
	};
	services.kdeconnect = {
		enable = true;
		indicator = true;
	};
	
}
