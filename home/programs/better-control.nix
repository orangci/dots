{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.better-control;
in
{
  options.hmModules.programs.better-control = {
    enable = mkEnableOption "Enable better-control";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      better-control
      pulseaudio
    ];
    wayland.windowManager.hyprland.settings.bind = lib.my.hyprlandLua.bindd [
      "SUPER, I, Open Settings, exec, control"
    ];
  };
}
