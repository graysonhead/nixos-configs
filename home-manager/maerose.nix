{ pkgs, ... }: {
	home.packages = with pkgs; [
		chrome
	];
}
