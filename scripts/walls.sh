#!/usr/bin/env bash

cd $HOME/media/walls
while : ; do
    export CURRENT_WALLPAPER="$(ls *.jpg *.png *.jpeg | sort -R | tail -1)"
    swww img $CURRENT_WALLPAPER --transition-type random --transition-fps 60
    echo "\$WALLPAPER=$HOME/media/walls/$CURRENT_WALLPAPER" > /tmp/.current_wallpaper_path_hyprlock
    export WALLPAPER="$HOME/media/walls/$CURRENT_WALLPAPER"
    echo "$WALLPAPER" > /tmp/.current_wallpaper_path
    sleep 1200
done