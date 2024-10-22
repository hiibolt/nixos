# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
let
  this_device_dir = ./.;
  lib_dir         = ../../lib;
  users_dir       = ../../users;
  workloads_dir   = ../../workloads;
  hardware_dir    = ../../hardware;

  system = {
    cpu = "intel";
    gpu = "amd";
    background = "6.jpg";

    keyboard = {
    layout = "semimak";
    device_id = "usb-SteelSeries_Apex_Pro_TKL_Wireless-if01-event-kbd";
    };
  };
in
{
  imports =
    [
      # Hardware
      (import ../../lib/disko/default.nix { device = "/dev/sda"; })
      "${this_device_dir}/hardware-configuration.nix"
      "${hardware_dir}/cpus/${system.cpu}.nix"

      # System Shell
      "${lib_dir}/shell/default.nix"

      # System drivers and daemons
      "${lib_dir}/maintenance/default.nix"
      "${lib_dir}/common/default.nix"
      "${lib_dir}/impermanence/default.nix"

      # Users
      "${users_dir}/hiibolt/user.nix"
      "${users_dir}/larkben/user.nix"
      "${users_dir}/root/default.nix"
      "${users_dir}/groups.nix"
    ];

  # Disable Auto-Suspend
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  # Networking
  networking = {
    hostName = "nuclearbombcell-3";
    networkmanager.enable = true;
  };

  # System Packages
	environment.systemPackages = with pkgs; [
    # Basic Development
		vim
		wget
  ];
  
  # State Version - Change with caution,
  #  but it's worth noting that since this
  #  system uses impermanent storage, it's
  #  likely a lot easier to recover from
  system.stateVersion = "24.11";
}
