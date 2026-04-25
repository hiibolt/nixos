# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, system, unstable-pkgs, ... }:
{
    imports =
        [
        # Hardware
        ./hardware-configuration.nix

        # Common (users, shell, kanata, system defaults)
        ../common.nix
        ];

    # Intel graphics drivers
    hardware = {
        graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = with pkgs; [
                intel-media-driver
                intel-compute-runtime
                intel-vaapi-driver
                libva-vdpau-driver
                libvdpau-va-gl
            ];
        };
    };

    # Hyprland
    programs.hyprland.enable = true;
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
    };

    # GNOME Keyring (persists NetworkManager credentials across reboots)
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    security.pam.services.login.enableGnomeKeyring = true;

    # Deploy Hyprland configs to hiibolt's home
    system.userActivationScripts.hyprland-config.text = ''
        dir="/home/hiibolt/.config/hypr"
        mkdir -p "$dir"
        ln -sf /etc/hypr/hyprland.conf "$dir/hyprland.conf"
        ln -sf /etc/hypr/hyprpaper.conf "$dir/hyprpaper.conf"
        dir="/home/hiibolt/.config/waybar"
        mkdir -p "$dir"
        ln -sf /etc/hypr/waybar-config.json "$dir/config"
        ln -sf /etc/hypr/waybar-style.css "$dir/style.css"
        dir="/home/hiibolt/.config/mako"
        mkdir -p "$dir"
        ln -sf /etc/hypr/mako-config "$dir/config"
    '';

    # Config files managed via /etc
    environment.etc."hypr/hyprland.conf".source = ./hyprland.conf;
    environment.etc."hypr/wallpaper.jpg".source = ./wallpaper.jpg;
    environment.etc."hypr/hyprpaper.conf".text = ''
        preload = /etc/hypr/wallpaper.jpg
        wallpaper = ,/etc/hypr/wallpaper.jpg
        splash = false
    '';
    environment.etc."hypr/waybar-config.json".source = ./waybar-config.json;
    environment.etc."hypr/waybar-style.css".source = ./waybar-style.css;
    environment.etc."hypr/mako-config".source = ./mako-config;

    # XDG portal for screen sharing etc.
    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    # `chown` `/etc/nixos` for `hiibolt`
    system.activationScripts.chown-nixos-hiibolt.text = ''
        chown -R hiibolt:nix-editor /etc/nixos
        chmod -R g+w /etc/nixos
    '';

    virtualisation.virtualbox.host.enable = true;

   	# Allow unfree packages and enable Nix Flakes
   	nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Networking
    networking = {
        hostName = "nuclearbombwarhead";
        networkmanager.enable = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };

    # Enable Bluetooth
    hardware.bluetooth.enable = true;

    # Enable Docker
    virtualisation.docker.enable = true;

   	# Enable sound with pipewire.
   	services.pulseaudio.enable = false;
   	security.rtkit.enable = true;
   	services.pipewire = {
  		enable = true;
  		alsa.enable = true;
  		alsa.support32Bit = true;
  		pulse.enable = true;
   	};

    # Enable `nix-ld`
    programs.nix-ld.enable = true;

    # System Packages
    environment.systemPackages = with pkgs; [
        # Basic Development
       	vim
       	wget

        # Web Browsing
       	librewolf

        # Recording
        (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            obs-backgroundremoval
            obs-pipewire-audio-capture
            droidcam-obs
        ];
        })

        # Windows Emulation / Games
        wine
        wineWowPackages.stable
        winetricks
        protontricks
        (unstable-pkgs.lutris.override {
            extraLibraries = pkgs: [
                libadwaita
                gtk4
            ];
            extraPkgs = pkgs: [
                pango
            ];
        })

        # Cursor
        bibata-cursors

        # Hyprland ecosystem
        wofi
        waybar
        mako
        hyprpaper
        hyprlock
        grim
        slurp
        wl-clipboard
        nemo
        brightnessctl
        playerctl
        networkmanagerapplet
        pavucontrol
    ];

    system.stateVersion = "24.11";
}
