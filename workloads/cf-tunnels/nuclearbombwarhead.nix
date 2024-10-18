{ config, lib, pkgs, inputs, ... }:
{
    sops.secrets = {
        "cf_tunnels/nuclearbombwarhead/token" = { 
            owner = "hiibolt";
        };
    };
    sops.templates."cf_tunnels/nuclearbombwarhead.env" = {
        content = ''
        TUNNEL_TOKEN=${config.sops.placeholder."cf_tunnels/nuclearbombwarhead/token"}
        '';
    };
    virtualisation.oci-containers.containers = {
        cloudflared = {
            image = "cloudflare/cloudflared:latest";
            ports = [ ];
            volumes = [ ];
            extraOptions = [
                "--network=host"
            ];
            environmentFiles = [
                /run/secrets-rendered/cf_tunnels/nuclearbombwarhead.env
            ];
            cmd = [
                "tunnel"
                "--no-autoupdate"
                "run"
            ];
        };
    };
}