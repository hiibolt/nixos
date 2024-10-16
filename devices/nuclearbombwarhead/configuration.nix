# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, ... }:
let
  this_device_dir = ./.;
  lib_dir         = ../../lib;
  users_dir       = ../../users;
  workloads_dir   = ../../workloads;
  hardware_dir    = ../../hardware;

  system = {
    hostname = "nuclearbombwarhead";
    cpu = "intel";
    gpu = "amd";
    background = "6.jpg";

    keyboard = {
    layout = "semimak";
    device = "by-id/usb-SteelSeries_Apex_Pro_TKL_Wireless-if01-event-kbd";
    };
  };
in
{
  imports =
    [
      # Hardware
      (import ../../lib/disko { device = "/dev/nvme0n1"; })
      "${this_device_dir}/hardware-configuration.nix"
      "${hardware_dir}/cpus/${system.cpu}.nix"
      "${hardware_dir}/gpus/${system.gpu}.nix"

      # System Shell
      "${lib_dir}/shell"

      # System daemons
      (import "${lib_dir}/kanata" {
        inherit config;
        inherit pkgs;
        layout = system.keyboard.layout;
        device = system.keyboard.device;
      })
      "${lib_dir}/impermanence"
      "${lib_dir}/maintenance"
      "${lib_dir}/common"

      # Workloads
      "${workloads_dir}/backends/docker.nix"
      "${workloads_dir}/socials"

      # Users
      "${users_dir}/hiibolt/user.nix"
      "${users_dir}/larkben/user.nix"
      "${users_dir}/root"
      "${users_dir}/groups.nix"
    ];

  # Enable the X11 windowing system with KDE Plasma 6
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Stylix
	stylix = {
    enable = true;
    image = /etc/nixos/backgrounds/${system.background};
	};

  # Disable Auto-Suspend
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

	# Enable sound with pipewire.
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

  # Networking
  networking = {
    hostName = system.hostname;
    networkmanager.enable = true;
  };

  # System Packages
	environment.systemPackages = with pkgs; [
    # Basic Development
		vim
		wget

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
