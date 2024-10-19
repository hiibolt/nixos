{ config, lib, pkgs, inputs, ... }:
{
    # Overarching Persistent Storage
    # Directory structure:
    # - Needs:
    #   - r6econ_assets
    #   - nocodb

    # Sherlock API - Handles Usernames and UUIDs
    sops.secrets = {
        "deployments/dykm/sherlock/port" = { 
            owner = "hiibolt";
        };
        "deployments/dykm/sherlock/proxy_link" = { 
            owner = "hiibolt";
        };
    };
    sops.templates."deployments/dykm/sherlock.env" = {
        content = ''
        PORT=${config.sops.placeholder."deployments/dykm/sherlock/port"}
        PROXY_LINK=${config.sops.placeholder."deployments/dykm/sherlock/proxy_link"}
        '';
    };
    virtualisation.oci-containers.containers = {
        dykm-sherlock = {
            image = "ghcr.io/hiibolt/sherlock-api:latest";
            ports = [ "127.0.0.1:8881:8881" ];
            volumes = [ ];
            extraOptions = [ ];
            environmentFiles = [
                /run/secrets-rendered/deployments/dykm/sherlock.env
            ];
            cmd = [ ];
        };
    };
    
    # NocoDB - Handles Database Management
    virtualisation.oci-containers.containers = {
        dykm-nocodb = {
            image = "nocodb/nocodb:latest";
            ports = [ 
                "127.0.0.1:8882:8080"
            ];
            volumes = [
                "/persist/workloads/dykm/nocodb:/usr/app/data"
            ];
            extraOptions = [ ];
            environmentFiles = [ ];
            cmd = [ ];
        };
    };

    # `osint-api` - Handles OSINT Data
    sops.secrets = {
        "deployments/dykm/osint-api/port" = { 
            owner = "hiibolt";
        };
        "deployments/dykm/osint-api/api_keys" = { 
            owner = "hiibolt";
        };
        "deployments/dykm/osint-api/sherlock_ws_url" = { 
            owner = "hiibolt";
        };
        "deployments/dykm/osint-api/bulkvs_api_key" = { 
            owner = "hiibolt";
        };
        "deployments/dykm/osint-api/snusbase_api_key" = { 
            owner = "hiibolt";
        };

        "deployments/dykm/osint-api/nocodb_api_key" = { 
            owner = "hiibolt";
        };
        "deployments/dykm/osint-api/nocodb_url" = { 
            owner = "hiibolt";
        };
        "deployments/dykm/osint-api/api_keys_table_id" = { 
            owner = "hiibolt";
        };
        "deployments/dykm/osint-api/api_usage_table_id" = { 
            owner = "hiibolt";
        };
        "deployments/dykm/osint-api/api_usage_link_field_id" = { 
            owner = "hiibolt";
        };

        "deployments/dykm/osint-api/proxy_link" = { 
            owner = "hiibolt";
        };
    };
    sops.templates."deployments/dykm/osint-api.env" = {
        content = ''
        PORT=${config.sops.placeholder."deployments/dykm/osint-api/port"}
        API_KEYS=${config.sops.placeholder."deployments/dykm/osint-api/api_keys"}
        SHERLOCK_WS_URL=${config.sops.placeholder."deployments/dykm/osint-api/sherlock_ws_url"}
        BULKVS_API_KEY=${config.sops.placeholder."deployments/dykm/osint-api/bulkvs_api_key"}
        SNUSBASE_API_KEY=${config.sops.placeholder."deployments/dykm/osint-api/snusbase_api_key"}

        NOCODB_API_KEY=${config.sops.placeholder."deployments/dykm/osint-api/nocodb_api_key"}
        NOCODB_URL=${config.sops.placeholder."deployments/dykm/osint-api/nocodb_url"}
        API_KEYS_TABLE_ID=${config.sops.placeholder."deployments/dykm/osint-api/api_keys_table_id"}
        API_USAGE_TABLE_ID=${config.sops.placeholder."deployments/dykm/osint-api/api_usage_table_id"}
        API_USAGE_LINK_FIELD_ID=${config.sops.placeholder."deployments/dykm/osint-api/api_usage_link_field_id"}

        PROXY_LINK=${config.sops.placeholder."deployments/dykm/osint-api/proxy_link"}
        '';
    };
    virtualisation.oci-containers.containers = {
        dykm-osint-api = {
            image = "ghcr.io/hiibolt/osint-api:latest";
            ports = [ "127.0.0.1:8883:8883" ];
            volumes = [ ];
            extraOptions = [
                "--network=host"
            ];
            environmentFiles = [
                /run/secrets-rendered/deployments/dykm/osint-api.env
            ];
            cmd = [ ];
        };
    };

    # DYKM - Frontend + Backend
    sops.secrets = {
        "deployments/dykm/dykm/port" = { 
            owner = "hiibolt";
        };
        "deployments/dykm/dykm/api_key" = { 
            owner = "hiibolt";
        };
    };
    sops.templates."deployments/dykm/dykm.env" = {
        content = ''
        PORT=${config.sops.placeholder."deployments/dykm/dykm/port"}
        API_KEY=${config.sops.placeholder."deployments/dykm/dykm/api_key"}
        '';
    };
    virtualisation.oci-containers.containers = {
        dykm-dykm = {
            image = "ghcr.io/hiibolt/dykm:latest";
            ports = [ "127.0.0.1:8880:8880" ];
            volumes = [ ];
            extraOptions = [ ];
            environmentFiles = [
                /run/secrets-rendered/deployments/dykm/dykm.env
            ];
            cmd = [ ];
        };
    };
}
