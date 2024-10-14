# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
let
  this_device_dir = ./.;
  lib_dir         = ../../lib;
  users_dir       = ../../users;
in
{
  imports =
    [
      # Hardware
      "${this_device_dir}/hardware/hardware-configuration.nix"
      "${this_device_dir}/hardware/fingerprint.nix"
      "${this_device_dir}/hardware/opengl.nix"
      (import ./hardware/disko.nix { device = "/dev/nvme0n1"; })
      "${lib_dir}/impermanence/default.nix"

      # System Shell
      "${lib_dir}/shell/default.nix"

      # System drivers and daemons
      (import "${lib_dir}/kanata/default.nix" {
        inherit config;
        inherit pkgs;
        keyboard_path = "${this_device_dir}/hardware/semimak.kbd";
      })
      "${lib_dir}/maintenance/default.nix"


      # Users
      "${users_dir}/hiibolt/user.nix"
      "${users_dir}/groups.nix"
    ];

  # Set the root password
  users.users.root = {
    initialPassword = "1234";
    # hashedPasswordFile = "/etc/nixos/devices/nuclearbombconsole/passwords/root.pw";
  };

  # Stylix
	stylix = {
    enable = true;
    image = /etc/nixos/backgrounds/6.jpg;
	};
 
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

	# Set your time zone.
	time.timeZone = "America/Chicago";

	# Add system fonts
	fonts.packages = [
		pkgs.nerdfonts
	];

  # Disable Auto-Suspend
  #systemd.targets = {
  #  sleep.enable = false;
  #  suspend.enable = false;
  #  hibernate.enable = false;
  #  hybrid-sleep.enable = false;
  #};

	# Select internationalisation properties.
	i18n = {
    defaultLocale = "en_US.UTF-8";
	  extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
      };
  };

  # Enable the X11 windowing system with KDE Plasma 6
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

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
    extraSetFlags = [
      "--ssh"
    ];
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
