{ config, lib, pkgs, inputs, ... }:
{
    # qBittorrent - Torrenting
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
                LAN_NETWORK="192.168.1.0/24, 100.64.0.0/10";
            };
            environmentFiles = [
                #/run/secrets-rendered/deployments/dykm/sherlock.env
            ];
            cmd = [ ];
        };
    };

    # FlareSolverr - Cloudflare Bypass
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

    # Prowlarr - Media Management
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

    # Jellyfin - Media Server
    virtualisation.oci-containers.containers = {
        media-jellyfin = {
            image = "jellyfin/jellyfin:latest";
            ports = [
                "127.0.0.1:8096:8096"
                "100.96.46.76:8096:8096"
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

    # Sonarr - Media Management (Anime)
    virtualisation.oci-containers.containers = {
        media-sonarr = {
            image = "linuxserver/sonarr:latest";
            ports = [
                "127.0.0.1:8989:8989"
                "100.96.46.76:8989:8989"
            ];
            volumes = [ 
                "/persist/workloads/media/sonarr/config:/config"
                "/persist/workloads/media/library/anime:/tv"
            ];
            extraOptions = [
                "--network=host"
            ];
            environment = {
                PUID="1000";
                PGID="1000";
            };
            environmentFiles = [ ];
            cmd = [ ];
        };
    };
}