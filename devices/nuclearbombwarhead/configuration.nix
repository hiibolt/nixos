# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, unstable-pkgs, inputs, ... }:
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
      #(import ./disko.nix { device = "/dev/nvme0n1"; })
      (import ../../lib/disko { device = "/dev/nvme0n1"; })
      "${this_device_dir}/hardware-configuration.nix"
      "${hardware_dir}/cpus/${system.cpu}.nix"
      "${hardware_dir}/gpus/${system.gpu}.nix"
      inputs.sops-nix.nixosModules.sops

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
      "${workloads_dir}/cf-tunnels/nuclearbombwarhead.nix"
      "${workloads_dir}/backends/docker.nix"
      "${workloads_dir}/deployments/hiibolt"
      "${workloads_dir}/deployments/media"
      "${workloads_dir}/deployments/r6rs"
      "${workloads_dir}/deployments/dykm"

      # Users
      "${users_dir}/hiibolt/user.nix"
      "${users_dir}/larkben/user.nix"
      "${users_dir}/root"
      "${users_dir}/groups.nix"
    ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/persist/var/lib/sops-nix/keys.txt";

  sops.secrets = {
    example-key = { };
    "myservice/my_subdir/my_secret" = { };
  };

  # Disable NVMe Write Cache
  services.udev.extraRules = 
    ''
    ACTION=="add", KERNEL=="nvme*", RUN+="${pkgs.nvme-cli}/bin/nvme set-feature -f 6 -V 0 %N"
    '';

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

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.corectrl = {
    enable = true;
  };

  # System Packages
	environment.systemPackages = with pkgs; [
    # Drives
    nvme-cli
    mdadm

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
