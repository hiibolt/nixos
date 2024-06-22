{ config, pkgs, ... }:
{	
  users.users.johnww = {
    isNormalUser = true;
    description = "hiibolt";
    extraGroups = [ "docker" "libvirtd" "networkmanager" "wheel" "dialout" "uinput" "input" ];
    packages = with pkgs; [
      cider
      stack
      logseq
      wireguard-go
      librewolf
      discord
      vesktop
      zoom-us
      awscli2 
      vscode
      electron
      libreoffice
      tetex
      tilix
      docker
      docker-compose
      (lutris.override {
        extraLibraries =  pkgs: [
          # List library dependencies here
        ];
      })
    ];
  };
}