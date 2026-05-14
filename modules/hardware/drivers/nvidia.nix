{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.hardware.drivers.nvidia;
in
{
  options.modules.hardware.drivers.nvidia.enable = mkEnableOption "Enable Nvidia Drivers";
  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      enabled = true;
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      prime = {
        offload.enable = true;
        intelBusId = mkIf config.modules.drivers.intel.enable "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1@0:0:0";
        amdgpuBusId = mkIf config.modules.drivers.amd.enable "PCI:5@0:0:0";
      };
    };
  };
}
