{ config, pkgs, ... }:

{
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vaapiVdpau
      libvdpau-va-gl
      vaapiIntel
      # intel-ocl
    ];
  };
}