{ config, lib, pkgs, inputs, ... }:
{
    virtualisation.oci-containers.containers = {
        socials = {
            image = "ghcr.io/hiibolt/socials:latest";
            ports = [ "127.0.0.1:4000:4000" ];
            volumes = [ ];
            cmd = [ ];
        };
    };
}