{ config, lib, pkgs, inputs, ... }:
{
    # Socials - Handles Social Media Links
    virtualisation.oci-containers.containers = {
        hiibolt-socials = {
            image = "ghcr.io/hiibolt/socials:latest";
            ports = [ "127.0.0.1:3001:4000" ];
            volumes = [ ];
            cmd = [ ];
        };
    };

    # Homepage - Handles Application Homepage
    virtualisation.oci-containers.containers = {
        hiibolt-homepage = {
            image = "ghcr.io/gethomepage/homepage:latest";
            ports = [
                #"127.0.0.1:4001:3000"
            ];
            volumes = [ 
                "/persist/workloads/hiibolt/homepage_config:/app/config"
                "/persist/workloads/hiibolt/homepage_config/images:/app/public/images"
                "/var/run/docker.sock:/var/run/docker.sock"
                "/var/run/podman/podman.sock:/var/run/podman.sock"
            ];
            extraOptions = [
                "--network=host"
                "--privileged"
            ];
            environmentFiles = [ ];
            cmd = [ ];
        };
    };
}