{ pkgs }:
pkgs.writeShellScriptBin "wallset" ''
  cd ~/Pictures/walls-catppuccin-mocha
  while : ; do
     export CURRENT_WALLPAPER="$(ls *.jpg *.png *.jpeg | sort -R | tail -1)"
     swww img $CURRENT_WALLPAPER --transition-type random --transition-fps 60
     export WALLPAPER=$HOME/Pictures/walls-catppuccin-mocha/$CURRENT_WALLPAPER
     sleep 120
  done
''
