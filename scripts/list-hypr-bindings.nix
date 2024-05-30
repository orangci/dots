{
  pkgs,
  host,
  ...
}: let
  inherit (import ../hosts/${host}/variables.nix) terminal browser;
in
  pkgs.writeShellScriptBin "list-hypr-bindings" ''
    yad --width=675 --height=950 \
    --center \
    --fixed \
    --title="Hyprland Keybindings" \
    --no-buttons \
    --list \
    --column=Keybind: \
    --column=Description: \
    --timeout=90 \
    --timeout-indicator=right \
    " = Windows/Super/CAPS LOCK" "Modifier Key, used for keybindings" \
    " + ENTER" "${terminal}" \
    "ALT + SPACE" "Rofi App Launcher" \
    " + Q" "Kill Focused Window" \
    " + SHIFT + W" "Search Websites Like Nix Packages" \
    " + R" "Execute Command (rofi)" \
    " + A" "Launch Notification Center" \
    " + W" "${browser}" \
    " + ." "Launch Emoji Selector" \
    " + V" "Open Clipboard" \
    " + SHIFT + V" "Clear Clipboard" \
    " + SHIFT + C" "Color Picker" \
    " + S" "Take Screenshot" \
    " + D" "Launch Discord" \
    " + C" "Launch vscodium" \
    " + O" "Launch Obsidian" \
    " + E" "Launch File Manager" \
    " + L" "Lock screen" \
    " + P" "Pause/Unpause Media" \
    " + ;" "Pseudo Tiling" \
    " + SHIFT + I" "Toggle Split Direction" \
    " + F" "Toggle Focused Fullscreen" \
    " + SHIFT + F" "Toggle Focused Floating" \
    " + SHIFT + C" "Quit / Exit Hyprland" \
    " + Left" "Move Focus To Window On The Left" \
    " + Right" "Move Focus To Window On The Right" \
    " + Up" "Move Focus To Window On The Up" \
    " + Down" "Move Focus To Window On The Down" \
    " + SHIFT + (Arrow keys)" "Move Focused Window in the direction of (arrow key)" \
    " + (Arrow keys)" "Move Focus To Window in the direction of (arrow key)" \
    " + SHIFT + LEFT" "Move Focused Window Left" \
    " + SHIFT + RIGHT" "Move Focused Window Right" \
    " + SHIFT + UP" "Move Focused Window Up" \
    " + SHIFT + DOWN" "Move Focused Window Down" \
    " + SPACE" "Switch keyboard layout" \
    " + 1-0" "Move To Workspace 1 - 10" \
    " + SHIFT + 1-0" "Move Focused Window To Workspace 1 - 10" \
    " + MOUSE_LEFT" "Move/Drag Window" \
    " + MOUSE_RIGHT" "Resize Window" \
    "ALT + TAB" "Cycle Window Focus + Bring To Front" \
    ""
  ''
