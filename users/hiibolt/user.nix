
{ config, lib, pkgs, inputs, ... }:

{
  # Create our primary user (`hiibolt`)
  users.users.hiibolt = {
    isNormalUser = true;
    description = "hiibolt";
    hashedPasswordFile = "/etc/nixos/users/hiibolt/passwords/hiibolt.pw";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
        # Development
        gh
        git

        # Web
		    librewolf

        # Vesktop
        vesktop

        # Shell Utilities
        fastfetch

        # Music
        (pkgs.callPackage ./cider/default.nix {})

        # Games
        osu-lazer-bin
        (lutris.override {
          extraLibraries = pkgs: [
            libadwaita
            gtk4
          ];	
          extraPkgs = pkgs: [
            pango
          ];
        })
    ];
  };
}