{ pkgs, host }:
let
inherit
    (import ../hosts/${host}/variables.nix) wlogout_horizontal;
in
pkgs.writeShellScriptBin "logout-exit" ''
  killall logout; wlogout --css ~/.config/wlogout/${if wlogout_horizontal then ''style_horizontal.css'' else ''style.css''} --layout ~/.config/wlogout/${if wlogout_horizontal then ''layout_horizontal'' else ''layout -b 2 -L 600 -R 600''} 
''
