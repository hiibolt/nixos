{ config, lib, pkgs, inputs, ... }:
{
    systemd.services.create-anb-server = {
        enable = true;
        description = "Create - Above N Beyond Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            WorkingDirectory = "/workloads/mc/create-anb-server";
            ExecStart = ''${pkgs.jdk8}/bin/java -Xmx8G -Xms8G \
              -Dsun.rmi.dgc.server.gcInterval=2147483646 \
              -XX:+UnlockExperimentalVMOptions \
              -XX:G1NewSizePercent=0 \
              -XX:G1ReservePercent=20 \
              -XX:MaxGCPauseMillis=50 \
              -XX:G1HeapRegionSize=32M \
              -XX:+UseG1GC \
              -jar ./forge-1.16.5-36.2.26.jar nogui'';
            Restart = "always";
            RestartSec = "30";
            User = "root";
        };
    };
}