{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ fprintd ];
	services.fprintd = {
		enable = true;
		tod = {
			driver = pkgs.libfprint-2-tod1-goodix;			
			enable = true;
		};
	};
}

