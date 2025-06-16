{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.hmModules.styles.walls;
in
{
  options.hmModules.styles.walls = {
    enable = mkEnableOption "Enable the wallpapers module";
    timeout = mkOption {
      type = types.ints.positive;
      default = 20;
      description = "Time between wallpaper changes (in minutes)";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.exec-once = [ "walls" ];
    home.packages = [
      (pkgs.writeShellScriptBin "walls" ''
        swww kill
        swww-daemon --no-cache & disown
        cd "$HOME/media/walls"
        while : ; do
            export CURRENT_WALLPAPER="$(ls *.jpg *.png *.jpeg 2>/dev/null | sort -R | tail -1)"
            swww img "$CURRENT_WALLPAPER" --transition-type random --transition-fps 60
            echo "\$WALLPAPER=$HOME/media/walls/$CURRENT_WALLPAPER" > /tmp/.current_wallpaper_path_hyprlock
            export WALLPAPER="$HOME/media/walls/$CURRENT_WALLPAPER"
            echo "$WALLPAPER" > /tmp/.current_wallpaper_path
            sleep $(( ${toString (cfg.timeout * 60)} ))
        done
      '')
      pkgs.swww
      pkgs.lutgen
    ];
  };
}
