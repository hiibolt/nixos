{ config, unstable-pkgs, pkgs, inputs, ... }:
{
    environment.systemPackages = with pkgs; [
        cudaPackages.cudatoolkit
    ];
    services.ollama = {
        enable = true;
        loadModels = [
            "deepseek-r1:1.5b"
        ];
        acceleration = "cuda";
        environmentVariables = {
            OLLAMA_ORIGINS = "https://r1.hiibolt.com";
        };
    };
    nixpkgs.config.cudaSupport = true;
    virtualisation.oci-containers.containers = {
        ai-deepseek-r1s = {
            image = "ghcr.io/hiibolt/deepseek-r1s@sha256:c1fafbb643a2db6be3303397ec89b0a7ef3fbb06886789a9229b07859857a51f";
            extraOptions = [
                "--network=host"
            ];
            ports = [
                "127.0.0.1:5776:5776"
            ];
            environment = {
                MODEL_NAME = "deepseek-r1:1.5b";
                SPAWN_OLLAMA = "false";
                DIFF_BASE_URL = "ws://r1.hiibolt.com/ws";
            };
        };
    };
}