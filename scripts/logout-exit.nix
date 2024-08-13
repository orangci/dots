{ pkgs }:
let
inherit (import ../hosts/helicon/variables.nix) wlogout_horizontal;
in
pkgs.writeShellScriptBin "logout-exit" ''
  wlogout --css ~/.config/wlogout/${if wlogout_horizontal then ''style_horizontal.css'' else ''style.css''} --layout ~/.config/wlogout/${if wlogout_horizontal then ''layout_horizontal -b 5 -T 400 -B 400'' else ''layout -b 2 -L 600 -R 600''} 
''
