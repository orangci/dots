{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.hardware.drivers.amd;
in
{
  options.modules.hardware.drivers.amd = {
    enable = mkEnableOption "AMD Drivers";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
    services.xserver.videoDrivers = [ "amdgpu" ];
    # vulkan comes from mesa's RADV, which is on by default (amdvlk was removed)
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
