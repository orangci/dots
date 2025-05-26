{
  pkgs,
  config,
  lib,
  username,
  ...
}: let
  inherit (lib) mkEnableOption types mkIf;
  cfg = config.hmModules.programs.hyprlock;
in {
  options.hmModules.programs.hyprlock = {
    enable = mkEnableOption "Enable hyprlock";
  };
  config = mkIf cfg.enable {
    home.packages = [pkgs.hyprlock];
    home.file.".config/hypr/hyprlock.conf".text = ''source = ~/dots/homes/orangc/programs/hyprlock/hyprlock.conf'';
    wayland.windowManager.hyprland.settings.bind = [
      "SUPER, l, exec, hyprlock"
      ",XF86HomePage, exec, hyprlock"
    ];
  };
}
