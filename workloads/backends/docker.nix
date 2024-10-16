{ config, lib, pkgs, inputs, ... }:
{
    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
    };

    users.users.hiibolt.extraGroups = [ "docker" ];
    users.users.larkben.extraGroups = [ "docker" ];
}