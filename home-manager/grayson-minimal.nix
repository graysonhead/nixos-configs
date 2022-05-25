{ pkgs, ... }: 
# Minimal home manager module for CLI only systems
{

	home.packages = with pkgs; [
		vim
		bind
		pciutils
		tmux
		htop
		nmon
		screen
		unzip
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

	programs.home-manager = {
		enable = true;
	};

	home.file = {
		".tmux.conf" = {
			text = ''
				setw -g mouse on
				bind -n -C-s set-window-option synchronize-panes
				'';
		};
	};
}
