{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf singleton;
  cfg = config.hmModules.widgets.syshud;
in
{
  options.hmModules.widgets.syshud.enable = mkEnableOption "Enable the syshud module";
  config = mkIf cfg.enable {
    home.packages = singleton pkgs.syshud;
    wayland.windowManager.hyprland.settings.exec-once = singleton "${pkgs.syshud}/bin/syshud -p right -o v";
  };
}
