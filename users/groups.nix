{ config, pkgs, ... }:
{	
	users.groups = {
		docker.members = [
			"hiibolt"
		];
		nix-editor.members = [
			"hiibolt"
		];
	};
}
