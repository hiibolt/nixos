
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
    extraGroups = [ "wheel" "docker" "vboxusers" ];
    packages = with pkgs; [
        # Development
        gh
        git
        postman
        skopeo
        racket
        argocd
        kubernetes-helm
        kubectl
        talosctl
        yq-go

        # Web & Office
		    librewolf
        libreoffice
        zoom-us
        (pkgs.wrapOBS {
          plugins = with pkgs.obs-studio-plugins; [
            obs-backgroundremoval
            obs-composite-blur
            droidcam-obs
          ];
        })

        # Note-taking
        anki

        # Vesktop
        vesktop

        # System Utilities
        fastfetch
        lsof
        sysstat
        nmap
        dnsutils
        inetutils
        tcpdump
        dnsutils
        tcpdump
        ethtool
        mtr
        droidcam
        inputs.kdiff.defaultPackage.${pkgs.stdenv.hostPlatform.system}
        inputs.talm.defaultPackage.${pkgs.stdenv.hostPlatform.system}
        caligula
        
        # Music
        spotify
        (pkgs.callPackage ./cider/default.nix {})

        # Games
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