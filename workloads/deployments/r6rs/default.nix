{ config, lib, pkgs, inputs, ... }:
{
    # Overarching Persistent Storage
    # Directory structure:
    # - Needs:
    #   - r6econ_assets
    #   - nocodb

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
            ports = [ "127.0.0.1:7771:7771" ];
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
                "127.0.0.1:7772:8080"
            ];
            volumes = [
                "/persist/workloads/r6rs/nocodb:/usr/app/data"
            ];
            extraOptions = [ ];
            environmentFiles = [ ];
            cmd = [ ];
        };
    };

    # R6RS - Handles the Bot
    sops.secrets = {
        "deployments/r6rs/r6rs/guild_id" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/r6rs/snusbase_api_key" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/r6rs/bulkvs_api_key" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/r6rs/database_api_key" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/r6rs/database_url" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/r6rs/command_table_id" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/r6rs/sherlock_ws_url" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/r6rs/openai_api_key" = { 
            owner = "hiibolt";
        };
        "deployments/r6rs/r6rs/port" = { 
            owner = "hiibolt";
        };
    };
    sops.templates."deployments/r6rs/r6rs.env" = {
        content = ''
        UBISOFT_AUTH_EMAIL=${config.sops.placeholder."deployments/r6rs/r6econ/ubi_auth_email"}
        UBISOFT_AUTH_PW=${config.sops.placeholder."deployments/r6rs/r6econ/ubi_auth_pw"}
        DISCORD_BOT_TOKEN=${config.sops.placeholder."deployments/r6rs/r6econ/discord_token"}
        PROXY_URL=${config.sops.placeholder."deployments/r6rs/sherlock/proxy_link"}

        GUILD_ID=${config.sops.placeholder."deployments/r6rs/r6rs/guild_id"}
        SNUSBASE_API_KEY=${config.sops.placeholder."deployments/r6rs/r6rs/snusbase_api_key"}
        BULKVS_API_KEY=${config.sops.placeholder."deployments/r6rs/r6rs/bulkvs_api_key"}
        DATABASE_API_KEY=${config.sops.placeholder."deployments/r6rs/r6rs/database_api_key"}
        DATABASE_URL=${config.sops.placeholder."deployments/r6rs/r6rs/database_url"}
        COMMAND_TABLE_ID=${config.sops.placeholder."deployments/r6rs/r6rs/command_table_id"}
        SHERLOCK_WS_URL=${config.sops.placeholder."deployments/r6rs/r6rs/sherlock_ws_url"}
        OPENAI_API_KEY=${config.sops.placeholder."deployments/r6rs/r6rs/openai_api_key"}
        PORT=${config.sops.placeholder."deployments/r6rs/r6rs/port"}
        '';
    };
    virtualisation.oci-containers.containers = {
        r6rs-r6rs = {
            image = "ghcr.io/hiibolt/r6rs:latest";
            ports = [ ];
            volumes = [
                "/persist/workloads/r6rs/r6econ_assets:/assets"
            ];
            extraOptions = [
                "--network=host"
            ];
            environmentFiles = [
                /run/secrets-rendered/deployments/r6rs/r6rs.env
            ];
            cmd = [ ];
        };
    };
}
