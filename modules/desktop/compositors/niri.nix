{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.desktop.compositors.niri;
in
{
  options.modules.desktop.compositors.niri = {
    enable = mkEnableOption "Enable niri";
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
    services.displayManager.dms-greeter.compositor.name = "niri";
  };
}
