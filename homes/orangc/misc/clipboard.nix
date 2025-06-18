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
    services.cliphist.enable = true;
    home.packages = with pkgs; [ wl-clipboard ];
    hmModules.cli.shell.extraAliases = {
      copy = "wl-copy";
      paste = "wl-paste";
    };
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];
      bindd = [
        "SUPER,  V, Open Clipboard, exec, cliphist list | rofi -dmenu -theme clipboard.rasi | cliphist decode | wl-copy"
        "SUPERSHIFT, V, Clear Clipboard, exec, cliphist wipe # clear clipboard"
      ];
    };
  };
}
