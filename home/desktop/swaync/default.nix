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
    enable = mkEnableOption "swaync";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.swaynotificationcenter ];
    home.file = {
      ".config/swaync/config.json".source = ./swaync.json;
      ".config/swaync/style.css".source = ./swaync.css;
    };
    wayland.windowManager.hyprland.settings = {
      layer_rule = map lib.my.hyprlandLua.layerRule [
        "match:namespace swaync-control-center, blur on"
        "match:namespace swaync-notification-window, blur on"
        "match:namespace swaync-control-center, ignore_alpha 0.8"
        "match:namespace swaync-notification-window, ignore_alpha 0.8"
      ];
      bind = lib.my.hyprlandLua.bindd [
        "SUPER, A, Open swaync Panel, exec, swaync-client -t "
        "SUPERSHIFT, A, Clear Notifications, exec, swaync-client -C"
      ];
    };
    wayland.windowManager.niri.settings = {
      _children = [
        {
          layer-rule = {
            match._props.namespace = "^swaync-(control-center|notification-window)$";
            background-effect = {
              blur = true;
              xray = false;
            };
          };
        }
      ];
      binds = {
        "Mod+A" = {
          _props.hotkey-overlay-title = "Open swaync Panel";
          spawn = [
            "swaync-client"
            "-t"
          ];
        };
        "Mod+Shift+A" = {
          _props.hotkey-overlay-title = "Clear Notifications";
          spawn = [
            "swaync-client"
            "-C"
          ];
        };
      };
    };
  };
}
