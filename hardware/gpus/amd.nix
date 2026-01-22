{ config, pkgs, ... }:
{
  # Enable OpenGL, AMD, and Intel graphics drivers.
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        # AMD Drivers
        rocmPackages.clr.icd
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];
  services.xserver.videoDrivers = [ "amdgpu" ]; 

  # HIP workaround
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
}