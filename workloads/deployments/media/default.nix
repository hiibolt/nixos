{ config, lib, pkgs, inputs, ... }:
let 
    jellyfin-rpc = pkgs.rustPlatform.buildRustPackage rec {
        pname = "jellyfin-rpc";
        version = "1.3.0";

        src = pkgs.fetchFromGitHub {
            owner =  "Radiicall";
            repo = "jellyfin-rpc";
            rev = "2393f16cf294253721dd9b9c9d6682c87ce5b5ac";
            hash = "sha256-sr82lTOr6RUvYD0CVZMyyRAFjai1oLnRWIszuu7/jE0=";
        };

        cargoHash = "sha256-KHbYM7aWgch+DWF46DpFCCt7JoKR0sasuFO3xPOytWA=";
    };
in
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
                "/persist/workloads/media/qbittorrent/qBittorrent/downloads:/downloads"
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

    # Sonarr - Media Management (TV/Anime)
    virtualisation.oci-containers.containers = {
        media-sonarr = {
            image = "linuxserver/sonarr:latest";
            ports = [
                "127.0.0.1:8989:8989"
                "100.96.46.76:8989:8989"
            ];
            volumes = [ 
                "/persist/workloads/media/sonarr/config:/config"
                "/persist/workloads/media/library/tv:/tv" 
                "/persist/workloads/media/qbittorrent/qBittorrent/downloads/:/downloads"
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

    # Jellyfin-RPC - Discord Status RPC for Jellyfin
    sops.secrets = {
        "deployments/media/jellyfin-rpc/jellyfin-api-key" = { 
            owner = "hiibolt";
        };
        "deployments/media/jellyfin-rpc/imgur-client-id" = { 
            owner = "hiibolt";
        };
    };
    sops.templates."deployments/media/jellyfin-rpc/main.json" = {
        owner = "hiibolt";
        content = ''
        {
            "jellyfin": {
                "url": "http://localhost:8096",
                "api_key": "${config.sops.placeholder."deployments/media/jellyfin-rpc/jellyfin-api-key"}",
                "username": [ "root", "hiibolt" ]
            },
            "imgur": {
                "client_id": "${config.sops.placeholder."deployments/media/jellyfin-rpc/imgur-client-id"}"
            },
            "images": {
                "enable_images": true,
                "imgur_images": true
            }
        }
        '';
    };
    systemd.user.services.media-jellyfin-rpc = {
        enable = true;
        description = "Jellyfin-RPC - Discord Status RPC for Jellyfin";
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
            ExecStart = "${jellyfin-rpc}/bin/jellyfin-rpc --config /run/secrets-rendered/deployments/media/jellyfin-rpc/main.json";
            Restart = "always";
            RestartSec = "30";
        };
    };


    #systemd.services.create-anb-server = {
    #    enable = true;
    #    description = "Create - Above N Beyond Server";
    #    after = [ "network.target" ];
    #    wantedBy = [ "multi-user.target" ];
    #    serviceConfig = {
    #        WorkingDirectory = "/workloads/mc/create-anb-server";
    #        ExecStart = ''${pkgs.jdk8}/bin/java -Xmx8G -Xms8G \
    #          -Dsun.rmi.dgc.server.gcInterval=2147483646 \
    #          -XX:+UnlockExperimentalVMOptions \
    #          -XX:G1NewSizePercent=0 \
    #          -XX:G1ReservePercent=20 \
    #          -XX:MaxGCPauseMillis=50 \
    #          -XX:G1HeapRegionSize=32M \
    #          -XX:+UseG1GC \
    #          -jar ./forge-1.16.5-36.2.26.jar nogui'';
    #        Restart = "always";
    #        RestartSec = "30";
    #        User = "root";
    #    };
    #};
}