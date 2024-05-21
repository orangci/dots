{ pkgs, config, lib, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) blender; in
lib.mkIf (blender == true) {
  home.packages = with pkgs; [
    pkgs.blender-hip
  ];
}
