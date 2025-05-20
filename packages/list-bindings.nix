{pkgs}:
pkgs.writeShellScriptBin "list-bindings" ''
  yad --width=950 --height=550 \
  --center \
  --fixed \
  --title="Keybindings" \
  --no-buttons \
  --list \
  --column=Key: \
  --column=Description: \
  --column=Key: \
  --column=Description: \
  --timeout=90 \
  --timeout-indicat \
  " + ENTER" "Terminal" " + K" "App launcher" \
  " + R" "Run command" " + M" "Minecraft launcher" \
  " + C" "Calculator" " + SHIFT + W" "Search websites" \
  " + A" "Open notifications" " + SHIFT + A" "Clear notifications" \
  " + W" "Launch Firefox" " + ." "Emoji picker" \
  " + S" "Take screenshot" " + SHIFT + M" "Mute microphone" \
  " + D" "Launch Discord" " + P" "Pause player" \
  " + SHIFT + P" "Next track" " + ALT + P" "Previous track" \
  " + SHIFT + C" "Launch VSCodium" " + O" "Start screen recording" \
  " + SHIFT + O" "Stop screen recording" " + G" "Launch Chrome" \
  " + E" "File browser" " + L" "Lock screen" \
  " + BACKSLASH" "Open power menu" " + APOSTRAPHE" "Change wallpaper" \
  " + V" "Open clipboard" " + SHIFT + V" "Clear clipboard" \
  " + ;" "Pseudo tiling" " + F" "Toggle fullscreen on focused" \
  " + B" "Toggle transparency on focused" " + SHIFT + F" "Toggle floating on focused" \
  " +    " "Move focus to arrow key direction" " + SHIFT +    " "Move focused window in arrow key direction" \
  " + 1-0" "Move to workspace 1 - 10" " + SHIFT + 1-0" "Move focused window to workspace 1 - 10" \
  " + LMB" "Drag window" " + RMB" "Resize window" \
  "ALT + TAB" "Cycle window focus" " + ALT + O" "Open recording center" \
''
