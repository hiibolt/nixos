{ config, pkgs, ... }:
let
  kubeMasterIP = "10.157.25.229";
  kubeMasterHostname = "nuclearbombwarhead";
  kubeMasterAPIServerPort = 6443;
in
{
  # Resolve master hostname
  networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";
  networking.firewall.allowedTCPPorts = [
      6443
      2379
      2380
      8080
  ];
  networking.firewall.allowedUDPPorts = [
      8472
  ];

  # Packages for administration tasks
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = kubeMasterHostname;
    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
    easyCerts = true;
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
    };

    # use coredns
    addons.dns.enable = true;

    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}