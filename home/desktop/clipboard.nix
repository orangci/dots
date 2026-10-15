{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf singleton;
  cfg = config.hmModules.desktop.clipboard;
in
{
  options.hmModules.desktop.clipboard.enable = mkEnableOption "clipboard";

  config = mkIf cfg.enable {
    services.cliphist.enable = !config.hmModules.desktop.walker.enable;
    home.packages = singleton pkgs.wl-clipboard;
    hmModules.cli.shell.extraAliases = {
      copy = "wl-copy";
      paste = "wl-paste";
    };

    wayland.windowManager.hyprland.settings = {
      on = mkIf (!config.hmModules.desktop.walker.enable) (
        map lib.my.hyprlandLua.onStart [
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
        ]
      );

      bind = mkIf (!config.hmModules.desktop.walker.enable) (
        lib.my.hyprlandLua.bindd [
          "SUPERSHIFT, V, Clear Clipboard, exec, cliphist wipe"
        ]
      );
    };
    wayland.windowManager.niri.settings = mkIf (!config.hmModules.desktop.walker.enable) {
      _children = [
        { spawn-sh-at-startup = "wl-paste --type text --watch cliphist store"; }
        { spawn-sh-at-startup = "wl-paste --type image --watch cliphist store"; }
      ];
      binds."Mod+Shift+V" = {
        _props.hotkey-overlay-title = "Clear Clipboard";
        spawn = [
          "cliphist"
          "wipe"
        ];
      };
    };
  };
}
