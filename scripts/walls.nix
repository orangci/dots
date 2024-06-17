{ pkgs }:
pkgs.writeShellScriptBin "wallset" ''
  cd ~/Pictures/walls-catppuccin-mocha
  swww kill
  swww-daemon
  while : ; do
     export CURRENT_WALLPAPER="$(ls *.jpg *.png *.jpeg | sort -R | tail -1)"
     swww img "$CURRENT_WALLPAPER" --transition-type grow --transition-duration 0.75 --transition-fps 60
     export CURRENT_WALLPAPER=$HOME/Pictures/walls-catppuccin-mocha/$CURRENT_WALLPAPER
     sleep 300
  done
''
