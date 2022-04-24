{ pkgs, ... }: {

	home.packages = with pkgs; [
		vim
		bind
		pciutils
		tmux
	];
        programs.git = {
		package = pkgs.gitAndTools.gitFull;
		enable = true;
		userName = "Grayson Head";
		userEmail = "grayson@graysonhead.net";
	};
	home.file = {
		".tmux.conf" = {
			text = ''
                        setw -g mouse on
                        '';
		};
	};
}
