{ pkgs, config, lib, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) cpuType; in
lib.mkIf ("${cpuType}" == "vm") {
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
}
