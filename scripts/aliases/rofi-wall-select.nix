{ pkgs }:
pkgs.writeShellScriptBin "rofi-wall-select" ''
  bash $HOME/dots/scripts/rofi/wall-select.sh
''