
{ config, lib, pkgs, inputs, ... }:

{ 
  # Create our secondary user (`larkben`)
  users.users.larkben = {
    isNormalUser = true;
    description = "larkben";
    initialPassword = "1234";
    # hashedPasswordFile = "/etc/nixos/users/larkben/passwords/larkben.pw";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
        # Development
        gh
        git

        # Web
		    librewolf

        # Shell Utilities
        fastfetch
    ];
  };
}