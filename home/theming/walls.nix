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
    singleton
    ;
  cfg = config.hmModules.theming.walls;
in
{
  options.hmModules.theming.walls = {
    enable = mkEnableOption "the wallpapers module";
    timeout = mkOption {
      type = types.ints.positive;
      default = 20;
      example = 5;
      description = "How often the wallpaper changes, in minutes.";
    };
    directory = mkOption {
      type = types.str;
      default = "${config.xdg.userDirs.pictures}/walls";
      example = "/home/orangc/media/walls";
      description = "The directory to pick random wallpapers from. Only `.jpg`, `.jpeg` and `.png` files directly inside it are used.";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.on = singleton (lib.my.hyprlandLua.onStart "walls");
    wayland.windowManager.niri.settings._children = singleton { spawn-at-startup = [ "walls" ]; };
    home.packages = [
      (pkgs.writeShellScriptBin "walls" ''
        # the daemon runs in the foreground, so background it and wait until it answers
        awww-daemon &
        until awww query > /dev/null 2>&1; do sleep 0.2; done
        cd ${cfg.directory}
        while : ; do
            export CURRENT_WALLPAPER="$(ls *.jpg *.png *.jpeg 2>/dev/null | sort -R | tail -1)"
            awww img "$CURRENT_WALLPAPER" --transition-type random --transition-fps 60 --transition-duration 1
            export WALLPAPER="${cfg.directory}/$CURRENT_WALLPAPER"
            echo "\$WALLPAPER=$WALLPAPER" > /tmp/.current_wallpaper_path_hyprlock
            echo "$WALLPAPER" > /tmp/.current_wallpaper_path
            sleep $(( ${toString (cfg.timeout * 60)} ))
        done
      '')
      pkgs.awww
      pkgs.lutgen
      pkgs.waypaper # selector. alternative to the rofi script
      # man i should scrap the rofi wallpaper selector and awww and just use wpaperd, but i don't want to...
    ];
  };
}
