{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.desktop.swaync;
in
{
  options.hmModules.desktop.swaync = {
    enable = mkEnableOption "Enable swaync";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.swaynotificationcenter ];
    home.file = {
      ".config/swaync/config.json".source = ./swaync.json;
      ".config/swaync/style.css".source = ./swaync.css;
    };
    wayland.windowManager.hyprland.settings = {
      layerrule = [
        "match:namespace swaync-control-center, blur on"
        "match:namespace swaync-notification-window, blur on"
        "match:namespace swaync-control-center, ignore_alpha 0.8"
        "match:namespace swaync-notification-window, ignore_alpha 0.8"
      ];
      bindd = [
        "SUPER, A, Open swaync Panel, exec, swaync-client -t "
        "SUPERSHIFT, A, Clear Notifications, exec, swaync-client -C"
      ];
    };
  };
}
