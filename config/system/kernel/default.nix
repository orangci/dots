{ config, lib, pkgs, host, ... }:

let inherit (import ../../../hosts/${host}/options.nix) theKernel; in
lib.mkIf (theKernel == "default") {
  boot.kernelPackages = pkgs.linuxPackages;
}
