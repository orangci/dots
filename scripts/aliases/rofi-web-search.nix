{ pkgs }:
pkgs.writeShellScriptBin "rofi-web-search" ''
  bash $HOME/dots/scripts/rofi/web-search.sh
''