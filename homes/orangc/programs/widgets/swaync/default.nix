{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.widgets.swaync;
in
{
  options.hmModules.programs.widgets.swaync = {
    enable = mkEnableOption "Enable swaync";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.swaynotificationcenter ];
    home.file.".config/swaync/config.json".source = ./swaync.json;
    home.file.".config/swaync/style.css".source = ./swaync.css;
    wayland.windowManager.hyprland.settings = {
      layerrule = [
        "blur,swaync-control-center"
        "blur,swaync-notification-window"
        "ignorezero,swaync-control-center"
        "ignorezero,swaync-notification-window"
        "ignorealpha 0.8,swaync-control-center"
        "ignorealpha 0.8,swaync-notification-window"
      ];
      bindd = [
        "SUPER, A, Open swaync Panel, exec, swaync-client -t "
        "SUPERSHIFT, A, Clear Notifications, exec, swaync-client -C"
      ];
    };
  };
}
