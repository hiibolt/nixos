# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, system, ... }:
let
  this_device_dir = ./.;
  lib_dir         = ../../lib;
  users_dir       = ../../users;
  workloads_dir   = ../../workloads;
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
      # Hardware
      (import ../../lib/disko/default.nix { device = "/dev/nvme0n1"; })
      "${this_device_dir}/hardware-configuration.nix"
      "${hardware_dir}/cpus/intel.nix"
      "${hardware_dir}/gpus/amd.nix"

      # System Shell
      "${lib_dir}/shell/default.nix"

      # System drivers and daemons
      (import "${lib_dir}/kanata/default.nix" {
        inherit config;
        inherit pkgs;
        layout = system.keyboard.layout;
        device = system.keyboard.device;
      })
      "${lib_dir}/impermanence/default.nix"
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

  # Stylix
	stylix = {
    enable = true;
    base16Scheme = {
      "base00" = "1b192e";
      "base01" = "47464c";
      "base02" = "796570";
      "base03" = "909ccc";
      "base04" = "acb8de";
      "base05" = "d3e5f1";
      "base06" = "ffebfa";
      "base07" = "fcecf9";
      "base08" = "909287";
      "base09" = "bc7d9c";
      "base0A" = "7e93a6";
      "base0B" = "a48b87";
      "base0C" = "7c90c5";
      "base0D" = "9e8c9c";
      "base0E" = "589f77";
      "base0F" = "9e86c0";
      "scheme" = "Stylix";
      "author" = "Stylix";
      "slug" = "stylix";
    };
    image = ../../backgrounds/11.jpg;
	};
  

  virtualisation.virtualbox.host.enable = true;

	# Allow unfree packages and enable Nix Flakes
	nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking
  networking = {
    hostName = "nuclearbombchassis";
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
  
  # State Version - Change with caution,
  #  but it's worth noting that since this
  #  system uses impermanent storage, it's
  #  likely a lot easier to recover from
  system.stateVersion = "24.11";
}
