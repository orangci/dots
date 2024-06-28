{ pkgs }:
pkgs.writeShellScriptBin "wallset" ''
  cd ~/Pictures/walls
  while : ; do
     export CURRENT_WALLPAPER="$(ls *.jpg *.png *.jpeg | sort -R | tail -1)"
     swww img $CURRENT_WALLPAPER --transition-type random --transition-fps 60
     echo "\$WALLPAPER=~/Pictures/walls/$CURRENT_WALLPAPER" > /tmp/.current_wallpaper_path_hyprlock
     export WALLPAPER=$HOME/Pictures/walls/$CURRENT_WALLPAPER
     echo "$WALLPAPER" > /tmp/.current_wallpaper_path
     sleep 120
  done
''
