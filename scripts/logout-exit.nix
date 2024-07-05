{ pkgs }:
pkgs.writeShellScriptBin "logout-exit" ''
  killall logout; wlogout --css ~/.config/wlogout/style.css --layout ~/.config/wlogout/layout -b 2 -L 600 -R 600
''
