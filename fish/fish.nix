{ config, pkgs, ... }:

{
  # Enables fish, a better shell, and adds launch arguments to allow for PROS development
  programs.fish.enable = true;
  programs.fish.shellInit = ''
    alias vex="/etc/nixos/.scripts/vex.sh"
    alias wro="/etc/nixos/.scripts/wro.sh"
    alias cfg="/etc/nixos/.scripts/cfg.sh"
    alias template="/etc/nixos/.scripts/get-template.sh"
  '';
  users.defaultUserShell = pkgs.fish;
  environment.systemPackages = with pkgs; [ fishPlugins.tide ];
  environment.shells = with pkgs; [ fish ];
}
