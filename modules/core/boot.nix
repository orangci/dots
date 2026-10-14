{
  config,
  lib,
  pkgs,
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
      kernelParams = singleton "usbcore.autosuspend=-1";
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
