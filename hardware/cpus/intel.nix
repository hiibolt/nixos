{ config, pkgs, ... }:
{
  # Enable OpenGL, AMD, and Intel graphics drivers.
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
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