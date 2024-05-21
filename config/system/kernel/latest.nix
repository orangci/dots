{ config, lib, pkgs, host, ... }:

let inherit (import ../../../hosts/${host}/options.nix) theKernel; in
lib.mkIf (theKernel == "latest") {
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
