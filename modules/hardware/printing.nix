{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption singleton;
  cfg = config.modules.hardware.printing;
in
{
  options.modules.hardware.printing.enable = mkEnableOption "Enable printing";
  config = lib.mkIf cfg.enable {
    hardware.sane.enable = true; # for scanners
    services = {
      printing = {
        enable = true;
        drivers = singleton pkgs.brgenml1cupswrapper;
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      ipp-usb.enable = true;
      samba.enable = true;
    };
  };
}
