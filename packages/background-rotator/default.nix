{ config, pkgs, ... }:
{
  # Load the backgrounds
  system.userActivationScripts = {
    background-rotater = {
      text = ''
        rm -rf ~/Pictures/Backgrounds; ln -s /etc/nixos/packages/background-rotator/backgrounds ~/Pictures/Backgrounds
      '';
    };
  };
}
