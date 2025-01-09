{ config, pkgs, ... }:
{
  # Enable OpenGL, AMD, and Intel graphics drivers.
  hardware = {
    graphics.enable32Bit = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        
      ];
    };
  };
}