{  config, lib, pkgs, inputs, ... }:
{
    networking.firewall.allowedTCPPorts = [
        6443
        2379
        2380
    ];
    networking.firewall.allowedUDPPorts = [
        8472
    ];

    services.k3s = {
        enable = true;

        role = "server";
        token = "meowmeowmeow";
        clusterInit = true;

        extraFlags = toString [
            # "--debug"
        ];
    };
}