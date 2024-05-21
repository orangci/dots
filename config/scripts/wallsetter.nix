{
  pkgs,
  username,
  wallpaperDir,
  wallpaperGit,
}:
pkgs.writeShellScriptBin "wallsetter" ''
  TIMEOUT=300
  TRANSITION1="--transition-type wave --transition-angle 120 --transition-step 30"
  TRANSITION2="--transition-type wipe --transition-angle 30 --transition-step 30"
  TRANSITION3="--transition-type center --transition-step 30"
  TRANSITION4="--transition-type outer --transition-pos 0.3,0.8 --transition-step 30"
  TRANSITION5="--transition-type wipe --transition-angle 270 --transition-step 30"
  WALLPAPER=$(find ${wallpaperDir} -name '*' | awk '!/.git/' | tail -n +2 | shuf -n 1)
  PREVIOUS=$WALLPAPER
  if [ -d ${wallpaperDir} ]; then
    num_files=$(ls -1 ${wallpaperDir} | wc -l)

    if [ $num_files -lt 1 ]; then
      notify-send -t 9000 "The wallpaper folder is expected to have more than 1 image. Exiting Wallsetter."
      exit
    else
      cd ${wallpaperDir}
      if [ -d ".git" ]; then
        git pull
      else
        notify-send -t 9000 "The wallpaper directory is expected to be a Git repository. Exiting Wallsetter."
        exit
      fi
    fi
  else
    ${pkgs.git}/bin/git clone ${wallpaperGit} ${wallpaperDir}
    chown -R ${username}:users ${wallpaperDir}
  fi
  while true;
  do
    if [ "$WALLPAPER" == "$PREVIOUS" ]; then
      WALLPAPER=$(find ${wallpaperDir} -name '*' | awk '!/.git/' | tail -n +2 | shuf -n 1)
    else
      PREVIOUS=$WALLPAPER
      NUM=$(shuf -e 1 2 3 4 5 -n 1)
      case $NUM in
        1)
          TRANSITION=$TRANSITION1
        ;;
        2)
          TRANSITION=$TRANSITION2
        ;;
        3)
          TRANSITION=$TRANSITION3
        ;;
        4)
          TRANSITION=$TRANSITION4
        ;;
        5)
          TRANSITION=$TRANSITION5
        ;;
      esac
      ${pkgs.swww}/bin/swww img "$WALLPAPER" $TRANSITION
      sleep $TIMEOUT
    fi
  done
''
