{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.core.printing;
in {
  options.modules.core.printing = {
    enable = mkEnableOption "Enable printing";
  };

  config = lib.mkIf cfg.enable {
    services = {
      printing = {
        enable = true;
        drivers = [pkgs.brgenml1cupswrapper];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      ipp-usb.enable = true;
      samba.enable = true;
    };
    hardware.sane.enable = true; # for scanners
  };
}
