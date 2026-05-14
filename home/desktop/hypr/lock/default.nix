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
    enable = mkEnableOption "Enable hyprlock";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.hyprlock ];
    home.file.".config/hypr/hyprlock.conf".text = "source = ${./hyprlock.conf}";
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER, l, Lock Screen, exec, hyprlock"
      ",XF86HomePage, Lock Screen, exec, hyprlock"
    ];
  };
}
