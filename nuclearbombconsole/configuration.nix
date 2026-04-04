# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, system, ... }:
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
