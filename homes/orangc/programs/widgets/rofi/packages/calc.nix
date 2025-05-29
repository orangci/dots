{ pkgs }:
pkgs.writeShellScriptBin "rofi-calc" ''
  # Prompt the user with rofi to enter input for rink
  INPUT=$(rofi -dmenu -p "Enter input for rink" -theme run.rasi)

  # Ensure the input is not empty
  if [ -n "$INPUT" ]; then
      # Pass the input to rink and copy the second line of the output to the clipboard
      rink "$INPUT" | sed -n '2p' | wl-copy
  else
      echo "No input provided."
  fi
''