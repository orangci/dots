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
    enable = mkEnableOption "Enable AMD Drivers";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.graphics.enable = true;
    hardware.opengl = {
      ## amdvlk: an open-source Vulkan driver from AMD
      extraPackages = [ pkgs.amdvlk ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
  };
}
