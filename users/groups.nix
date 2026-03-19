{ config, pkgs, ... }:
let 
	primary_users = [ "hiibolt" ];
in
{	
	users.groups = {
		docker.members = primary_users;
		nix-editor.members = primary_users;
		libvirtd.members = primary_users;
		uinput.members = primary_users;
		input.members = primary_users;
	};
}
