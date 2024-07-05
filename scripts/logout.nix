{ pkgs }:
pkgs.writeShellScriptBin "logout" ''
  killall logout; wlogout --css ~/.config/wlogout/style.css --layout ~/.config/wlogout/layout -b 2 -L 610 -R 610
''
