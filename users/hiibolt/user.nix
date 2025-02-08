
{ config, lib, pkgs, inputs, ... }:

{ 
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];

  # Create our primary user (`hiibolt`)
  users.users.hiibolt = {
    isNormalUser = true;
    description = "hiibolt";
    initialPassword = "1234";
    # hashedPasswordFile = "/etc/nixos/users/hiibolt/passwords/hiibolt.pw";
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
        # Development
        gh
        git
        postman
        skopeo

        # Web
		    librewolf

        # Note-taking
        logseq

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