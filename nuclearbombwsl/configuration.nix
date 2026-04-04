# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:
{
  imports =
    [
      # Common (users, shell, kanata, system defaults)
      ../common.nix
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

  system.stateVersion = "24.05";
}
