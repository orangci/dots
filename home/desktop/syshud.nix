{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf singleton;
  cfg = config.hmModules.desktop.syshud;
in
{
  options.hmModules.desktop.syshud.enable = mkEnableOption "Enable the syshud module";
  config = mkIf cfg.enable {
    home.packages = singleton pkgs.syshud;
    wayland.windowManager.hyprland.settings.on = singleton (
      lib.my.hyprlandLua.onStart "${pkgs.syshud}/bin/syshud -p right -o v"
    );
  };
}
