{ pkgs }:
pkgs.writeShellScriptBin "rofi-wall-select" ''
  chmod +x $HOME/dots/scripts/rofi-wall-select.sh
  bash $HOME/dots/scripts/rofi-wall-select.sh
''
