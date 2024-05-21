{ pkgs, config, lib, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) kdenlive; in
lib.mkIf (kdenlive == true) {
  home.packages = with pkgs; [
    pkgs.kdenlive
  ];
}
