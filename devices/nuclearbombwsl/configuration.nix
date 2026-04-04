# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:
let
  this_device_dir = ./.;
  lib_dir         = ../../lib;
  users_dir       = ../../users;
  hardware_dir    = ../../hardware;

  system = {
    background = "11.jpg";

    keyboard = {
      layout = "semimak";
      device = "by-path/pci-0000\\:00\\:14.0-usb-0\\:2.2\\:1.1-event-kbd";
    };
  };
in
{
imports =
    [
      # System Shell
      "${lib_dir}/shell/default.nix"

      # System drivers and daemons
      "${lib_dir}/maintenance/default.nix"
      "${lib_dir}/common/default.nix"

      # Users
      "${users_dir}/hiibolt/user.nix"
      "${users_dir}/root/default.nix"
      "${users_dir}/groups.nix"
    ];

  wsl.enable = true;
  wsl.defaultUser = "hiibolt";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# Networking
  networking = {
    hostName = "nuclearbombwsl";
    networkmanager.enable = true;
  };
  services.openssh.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  # System Packages
	environment.systemPackages = with pkgs; [
    # Basic Development
		vim
		wget
    gimp
    kubectl
    xdg-desktop-portal

    # Web Browsing
		librewolf

    # Windows Emulation
    wine
    wineWowPackages.stable
    winetricks
    protontricks
  ];

  programs.nix-ld = {
	enable = true;
	package = pkgs.nix-ld;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
 # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
