{ pkgs, config, lib, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) enableZeroAD; in
lib.mkIf (enableZeroAD == true) {
  home.packages = with pkgs; [
    zeroad
  ];
}
