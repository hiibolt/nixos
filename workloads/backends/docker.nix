{ config, lib, pkgs, inputs, ... }:
{
    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
    };

    users.users.hiibolt.extraGroups = [ "docker" "podman" ];
}