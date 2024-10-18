{ config, lib, pkgs, inputs, ... }:
{
    virtualisation.oci-containers.containers = {
        jellyfin = {
            image = "binhex/arch-jellyfin";
            ports = [ "127.0.0.1:8096:8096" ];
            volumes = [ ];
            cmd = [ ];
        };
    };
}