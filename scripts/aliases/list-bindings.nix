{ pkgs }:
pkgs.writeShellScriptBin "list-bindings" ''
  bash $HOME/dots/scripts/list-bindings.sh
''