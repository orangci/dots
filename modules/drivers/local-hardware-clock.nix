{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.local.hardware-clock;
in
{
  options.local.hardware-clock = {
    enable = mkEnableOption "Change the hardware clock to local time";
  };

  config = mkIf cfg.enable { time.hardwareClockInLocalTime = true; };
}
