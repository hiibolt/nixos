{ config, pkgs, ... }:
{
  # Enable OpenGL, AMD, and Intel graphics drivers.
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      # AMD Drivers
      rocmPackages.clr.icd
      amdvlk
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };
  services.xserver.videoDrivers = [ "amdgpu" ]; 

  # HIP workaround
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
}