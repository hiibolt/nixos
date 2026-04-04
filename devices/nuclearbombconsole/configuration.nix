# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, system, ... }:
let
  this_device_dir = ./.;
  lib_dir         = ../../lib;
  users_dir       = ../../users;
  hardware_dir    = ../../hardware;

  system = {
    cpu = "intel";
    gpu = "";
    background = "6.jpg";

    keyboard = {
    layout = "semimak";
    device = "by-path/platform-i8042-serio-0-event-kbd";
    };
  };
in
{
  imports =
    [
      # Hardware
      "${this_device_dir}/hardware-configuration.nix"
      "${hardware_dir}/cpus/${system.cpu}.nix"

      # System Shell
      "${lib_dir}/shell/default.nix"

      # System drivers and daemons
      (import "${lib_dir}/kanata/default.nix" {
        inherit config;
        inherit pkgs;
        layout = system.keyboard.layout;
        device = system.keyboard.device;
      })
      "${lib_dir}/maintenance/default.nix"
      "${lib_dir}/common/default.nix"
      "${lib_dir}/fingerprint/default.nix"

      # Users
      "${users_dir}/hiibolt/user.nix"
      "${users_dir}/root/default.nix"
      "${users_dir}/groups.nix"
    ];

  # Enable the X11 windowing system with KDE Plasma 6
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

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
    hostName = "nuclearbombconsole";
    networkmanager.enable = true;
  };
  services.openssh.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
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

    # Windows Emulation
    wine
    wineWowPackages.stable
    winetricks
    protontricks
  ];
  
  system.stateVersion = "24.11";
}
