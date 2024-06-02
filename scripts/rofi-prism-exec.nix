{ pkgs }:
pkgs.writeShellScriptBin "rofi-prism-exec" ''
  chmod +x $HOME/.config/rofi/rofi-prism.sh
  bash $HOME/.config/rofi/rofi-prism.sh
''
