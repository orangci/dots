{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption types mkIf;
  cfg = config.hmModules.programs.hypridle;
in {
  options.hmModules.programs.hypridle = {
    enable = mkEnableOption "Enable hypridle";
  };
  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
          unlock_cmd = "pkill -USR1 hyprlock";
        };
        listener = [
          {
            timeout = 2 * 60; # minutes * 60 = seconds
            on-timeout = "hyprlock";
          }
          {
            timeout = 60 * 60; # minutes * 60 = seconds
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
