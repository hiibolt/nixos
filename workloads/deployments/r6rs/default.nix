{ config, lib, pkgs, inputs, ... }:
{
    # Overarching Persistent Storage
    environment.persistence."/persist" = {
        directories = [
            "/workloads/r6rs/r6econ_assets"
            "/workloads/r6rs/nocodb"
        ];
    };

    # Sherlock API - Handles Usernames and UUIDs
    sops.secrets = {
        "deployments/r6rs/sherlock/port" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/sherlock/proxy_link" = { 
            owner = "hiibolt";
        };
    };
    sops.templates."deployments/r6rs/sherlock.env" = {
        content = ''
        PORT=${config.sops.placeholder."deployments/r6rs/sherlock/port"}
        PROXY_LINK=${config.sops.placeholder."deployments/r6rs/sherlock/proxy_link"}
        '';
    };
    virtualisation.oci-containers.containers = {
        r6rs-sherlock = {
            image = "ghcr.io/hiibolt/sherlock-api:latest";
            ports = [ "127.0.0.1:7780:7780" ];
            volumes = [ ];
            extraOptions = [ ];
            environmentFiles = [
                /run/secrets-rendered/deployments/r6rs/sherlock.env
            ];
            cmd = [ ];
        };
    };

    # R6Econ - Handles Economy and User Data
    sops.secrets = {
        "deployments/r6rs/r6econ/ubi_auth_email" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/r6econ/ubi_auth_pw" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/r6econ/discord_token" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/r6econ/disable_commands" = { 
            owner = "hiibolt";
        };
    };
    sops.templates."deployments/r6rs/r6econ.env" = {
        content = ''
        AUTH_EMAIL=${config.sops.placeholder."deployments/r6rs/r6econ/ubi_auth_email"}
        AUTH_PW=${config.sops.placeholder."deployments/r6rs/r6econ/ubi_auth_pw"}
        TOKEN=${config.sops.placeholder."deployments/r6rs/r6econ/discord_token"}
        NO_COMMANDS=${config.sops.placeholder."deployments/r6rs/r6econ/disable_commands"}
        '';
    };
    virtualisation.oci-containers.containers = {
        r6rs-r6econ = {
            image = "ghcr.io/hiibolt/r6econ:latest";
            ports = [ ];
            volumes = [
                "/persist/workloads/r6rs/r6econ_assets:/app/assets"
            ];
            extraOptions = [ ];
            environmentFiles = [
                /run/secrets-rendered/deployments/r6rs/r6econ.env
            ];
            cmd = [ ];
        };
    };
    
    # NocoDB - Handles Database Management
    virtualisation.oci-containers.containers = {
        r6rs-nocodb = {
            image = "nocodb/nocodb:latest";
            ports = [ 
                "127.0.0.1:8088:8080"
            ];
            volumes = [
                "/persist/workloads/r6rs/nocodb:/usr/app/data"
            ];
            extraOptions = [ ];
            environmentFiles = [ ];
            cmd = [ ];
        };
    };
}