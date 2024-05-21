{ config, lib, options, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) ntp; in
lib.mkIf (ntp == true) {
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
}
