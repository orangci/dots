{ host, ... }:
let
  inherit (import ../hosts/${host}/variables.nix) waybarStyle;
in
{
  imports = [ ./waybar-styles/${waybarStyle}.nix ];
}
