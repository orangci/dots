{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.common.virtualisation;
in
{
  options.modules.common.virtualisation = {
    enable = mkEnableOption "Enable libvirtd";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
  };
}
