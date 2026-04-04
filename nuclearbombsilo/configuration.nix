{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Mount exports
  fileSystems."/mnt/meow" = {
     device = "/dev/sdc";
     fsType = "ext4";
     options = [
         "users"
         "nofail"
         "exec"
     ];
  };
  services.nfs.server = {
     enable = true;
     exports = ''
        /mnt/meow 192.168.1.0/24(rw,sync,no_root_squash,no_subtree_check,no_all_squash)
     '';
  };

  networking.hostName = "nuclearbombsilo";

  services.tailscale = {
     enable = true;
  };

  networking.networkmanager.enable = true;
  networking.firewall = {
     enable = true;
     allowedTCPPorts = [ 2049 ];
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.hiibolt = {
     isNormalUser = true;
     extraGroups = [ "wheel" ];
     packages = with pkgs; [

     ];
   };

  environment.systemPackages = with pkgs; [
     vim
     wget
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
