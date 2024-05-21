{ config, lib, pkgs, host, ... }:

let inherit (import ../../../hosts/${host}/options.nix) theKernel; in
lib.mkIf (theKernel == "xanmod") {
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
