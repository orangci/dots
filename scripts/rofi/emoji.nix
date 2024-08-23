{pkgs}:
pkgs.writeShellScriptBin "emoji-select" ''
  # Get user selection via rofi from emoji file.
  chosen=$(cat $HOME/dots/files/emoji | rofi -i -dmenu -theme clipboard.rasi | awk '{print $1}')

  # Exit if none chosen.
  [ -z "$chosen" ] && exit

  # If you run this command with an argument, it will automatically insert the
  # character. Otherwise, show a message that the emoji has been copied.
  if [ -n "$1" ]; then
  wtype "$chosen"
  else
      printf "$chosen" | wl-copy
  fi

''
