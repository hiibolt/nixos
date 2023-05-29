{ config, pkgs, ... }:

{
  # Enables fish, a better shell, and adds launch arguments to allow for PROS development
  programs.fish.enable = true;
  programs.fish.shellInit = ''
    echo "Hii ~"
  '';
  users.defaultUserShell = pkgs.fish;
  environment.systemPackages = with pkgs; [ fishPlugins.tide ];
  environment.shells = with pkgs; [ fish ];
}
