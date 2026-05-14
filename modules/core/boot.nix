{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption singleton;
  cfg = config.modules.core.boot;
in
{
  options.modules.core.boot.enable = mkEnableOption "boot(loader) configuration";
  config = lib.mkIf cfg.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = singleton "v4l2loopback";
      extraModulePackages = singleton config.boot.kernelPackages.v4l2loopback;
      plymouth.enable = true;
      kernel.sysctl."vm.max_map_count" = 2147483642;
      loader = {
        efi.efiSysMountPoint = "/boot";
        systemd-boot = {
          enable = true;
          consoleMode = "max";
        };
        efi.canTouchEfiVariables = true;
        grub.enable = false;
      };
      tmp = {
        useTmpfs = false;
        tmpfsSize = "30%";
      };
    };
  };
}
