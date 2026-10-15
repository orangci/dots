{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.desktop.hypr.lock;
in
{
  options.hmModules.desktop.hypr.lock = {
    enable = mkEnableOption "hyprlock";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.hyprlock ];
    home.file.".config/hypr/hyprlock.conf".text = "source = ${./hyprlock.conf}";
    wayland.windowManager.hyprland.settings.bind = lib.my.hyprlandLua.bindd [
      "SUPER, l, Lock Screen, exec, hyprlock"
      ",XF86HomePage, Lock Screen, exec, hyprlock"
    ];
    wayland.windowManager.niri.settings.binds = {
      "Mod+L" = {
        _props.hotkey-overlay-title = "Lock Screen";
        spawn = [ "hyprlock" ];
      };
      "XF86HomePage".spawn = [ "hyprlock" ];
    };
  };
}
