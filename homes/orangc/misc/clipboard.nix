{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.misc.clipboard;
in
{
  options.hmModules.misc.clipboard.enable = mkEnableOption "Enable clipboard with cliphist";

  config = mkIf cfg.enable {
    services.cliphist.enable = !config.hmModules.programs.widgets.walker.enable;

    home.packages = with pkgs; [ wl-clipboard ];

    hmModules.cli.shell.extraAliases = {
      copy = "wl-copy";
      paste = "wl-paste";
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf (!config.hmModules.programs.widgets.walker.enable) [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      bindd = [
        (mkIf config.hmModules.programs.widgets.rofi.enable "SUPER, V, Open Clipboard, exec, cliphist list | rofi -dmenu -theme clipboard.rasi | cliphist decode | wl-copy")

        (mkIf (
          !config.hmModules.programs.widgets.walker.enable
        ) "SUPERSHIFT, V, Clear Clipboard, exec, cliphist wipe")
      ];
    };
  };
}
