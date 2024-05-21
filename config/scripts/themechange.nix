{ pkgs, host, ... }:

let 
  inherit (import ../../hosts/${host}/options.nix) flakeDir hostname;
in
pkgs.writeShellScriptBin "themechange" ''
  if [[ ! $@ ]];then
    echo "No Theme Given"
  else
    replacement="$1"
    sed -i "/^\s*theme[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$replacement\"/" ${flakeDir}/hosts/${host}/options.nix
    kitty -e pkexec nixos-rebuild switch --flake ${flakeDir}
  fi
''
