{ config, lib, pkgs, inputs, ... }:
{
    # qBittorrent
    #sops.secrets = {
    #    "deployments/dykm/sherlock/port" = { 
    #        owner = "hiibolt";
    #    };
    #    "deployments/dykm/sherlock/proxy_link" = { 
    #        owner = "hiibolt";
    #    };
    #};
    #sops.templates."deployments/dykm/sherlock.env" = {
    #    content = ''
    #    PORT=${config.sops.placeholder."deployments/dykm/sherlock/port"}
    #    PROXY_LINK=${config.sops.placeholder."deployments/dykm/sherlock/proxy_link"}
    #    '';
    #};
    virtualisation.oci-containers.containers = {
        media-qbittorrentvpn = {
            image = "linuxserver/qbittorrent:latest";
            ports = [
                "127.0.0.1:6881:6881/udp"
                "127.0.0.1:6881:6881"
                "127.0.0.1:8080:8080"
            ];
            volumes = [ 
                "/persist/workloads/media/qbittorrent:/config"
                "/persist/workloads/media/library:/downloads"
            ];
            extraOptions = [
                "--privileged"
            ];
            environment = {
                PUID="1000";
                PGID="1000";
                TZ="America/New_York";
                WEBUI_PORT="8080";
                TORRENTING_PORT="6881";
            };
            environmentFiles = [
                #/run/secrets-rendered/deployments/dykm/sherlock.env
            ];
            cmd = [ ];
        };
    };
    virtualisation.oci-containers.containers = {
        media-flaresolverr = {
            image = "ghcr.io/flaresolverr/flaresolverr:latest";
            ports = [
                "127.0.0.1:8191:8191"
            ];
            volumes = [ ];
            extraOptions = [ ];
            environment = { };
            environmentFiles = [ ];
            cmd = [ ];
        };
    };
    virtualisation.oci-containers.containers = {
        media-prowlarr = {
            image = "lscr.io/linuxserver/prowlarr:latest";
            ports = [
                "127.0.0.1:9696:9696"
            ];
            volumes = [ 
                "/persist/workloads/media/prowlarr:/config"
            ];
            extraOptions = [
                "--network=host"
            ];
            environment = {
                PUID="1000";
                PGID="1000";
                TZ="America/New_York";
            };
            environmentFiles = [ ];
            cmd = [ ];
        };
    };
    virtualisation.oci-containers.containers = {
        media-jellyfin = {
            image = "jellyfin/jellyfin:latest";
            ports = [
                "127.0.0.1:8096:8096"
            ];
            volumes = [ 
                "/persist/workloads/media/jellyfin/config:/config"
                "/persist/workloads/media/jellyfin/cache:/downloads"
            ];
            extraOptions = [
                "--privileged"
                "--mount"
                "type=bind,source=/persist/workloads/media/library,target=/media"
            ];
            environment = {
                PUID="1000";
                PGID="1000";
            };
            environmentFiles = [
                #/run/secrets-rendered/deployments/dykm/sherlock.env
            ];
            cmd = [ ];
        };
    };
}