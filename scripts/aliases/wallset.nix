{ pkgs }:
pkgs.writeShellScriptBin "wallset" ''
  bash $HOME/dots/scripts/walls.sh
''