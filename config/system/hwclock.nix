{ config, lib, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) localHWClock; in
lib.mkIf (localHWClock == true) {
  time.hardwareClockInLocalTime = true;
}
