{ pkgs, config, lib, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) logitech; in
lib.mkIf (logitech == true) {
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;
}
