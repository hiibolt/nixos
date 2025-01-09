{ config, pkgs, ... }:
{
  # Enable OpenGL, AMD, and Intel graphics drivers.
  hardware = {
    graphics.enable32Bit = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        # Intel Drivers
        intel-media-driver
        intel-compute-runtime
        vaapiVdpau
        libvdpau-va-gl
        vaapiIntel
      ];
    };
  };
}