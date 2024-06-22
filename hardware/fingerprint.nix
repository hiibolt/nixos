{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ fprintd libfprint ];
	services.fprintd = {
		enable = true;
	};
}