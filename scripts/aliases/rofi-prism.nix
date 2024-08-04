{ pkgs }:
pkgs.writeShellScriptBin "rofi-prism" ''
  bash $HOME/dots/scripts/rofi/prism.sh
''