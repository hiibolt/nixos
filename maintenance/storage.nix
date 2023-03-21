{ config, pkgs, ... }:

{
	# Automatically clean the Nix store
	nix.settings.auto-optimise-store = true;

	# Automate garbage collection for old generations
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 5d";
	};	
}
