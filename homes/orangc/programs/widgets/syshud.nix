{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf singleton;
  cfg = config.hmModules.programs.widgets.syshud;
in
{
  options.hmModules.programs.widgets.syshud.enable = mkEnableOption "Enable the syshud module";
  config = mkIf cfg.enable {
    home.packages = singleton pkgs.syshud;
    wayland.windowManager.hyprland.settings.exec-once =
      singleton "${pkgs.syshud}/bin/syshud -p right -o v";
  };
}
