{
  config,
  lib,
  flakeSettings,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    singleton
    ;
  cfg = config.modules.services.monitoring.ntfy.scripts.temperature;
  ntfy = config.modules.services.monitoring.ntfy;

  ntfyUrl = "https://${ntfy.subdomain}.${flakeSettings.domains.primary}/${cfg.topic}";

  script = pkgs.writeShellApplication {
    name = "ntfy-script-temperature";
    runtimeInputs = with pkgs; [
      coreutils
      ntfy-sh
    ];
    text = ''
      threshold=${toString cfg.threshold}
      hot=0

      # the ntfy-access-token secret holds NTFY_ACCESS_TOKEN=...
      token="''${NTFY_ACCESS_TOKEN:-''${NTFY_TOKEN:-}}"

      notify() {
        ntfy publish --quiet --priority "$1" --token "$token" ${ntfyUrl} "$2" || true
      }

      # hottest thermal zone, in whole degrees celsius
      hottest() {
        local max=0 raw
        for zone in /sys/class/thermal/thermal_zone*/temp; do
          raw=$(cat "$zone" 2>/dev/null) || continue
          (( raw > max )) && max=$raw
        done
        echo $(( max / 1000 ))
      }

      while true; do
        temp=$(hottest)
        if (( temp >= threshold )) && (( hot == 0 )); then
          notify high "${config.networking.hostName} is running hot: $temp°C"
          hot=1
        # a 5 degree margin stops it flapping around the threshold
        elif (( temp < threshold - 5 )) && (( hot == 1 )); then
          notify low "${config.networking.hostName} has cooled down: $temp°C"
          hot=0
        fi
        sleep ${toString cfg.interval}
      done
    '';
  };
in
{
  options.modules.services.monitoring.ntfy.scripts.temperature = {
    enable = mkEnableOption "temperature script for Ntfy";
    topic = mkOption {
      type = types.str;
      default = "temperature";
      description = "The ntfy topic that overheating and cooled-down notifications are published to. It is readable by everyone, see the `acl` option of the ntfy module.";
    };
    threshold = mkOption {
      type = types.ints.positive;
      default = 90;
      example = 95;
      description = "The temperature in degrees celsius at which to notify. The hottest thermal zone counts.";
    };
    interval = mkOption {
      type = types.ints.positive;
      default = 60;
      description = "How often to check the temperature, in seconds.";
    };
  };

  config = mkIf cfg.enable {
    modules.services.monitoring.ntfy.acl = singleton "*:${cfg.topic}:read";
    systemd.services.ntfy-script-temperature = {
      description = "Ntfy temperature script";
      after = [ "ntfy-sh.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${script}/bin/ntfy-script-temperature";
        Restart = "always";
        RestartSec = 5;
        User = "ntfy-sh";
        EnvironmentFile = config.modules.security.sops.secrets.ntfy-access-token.path;
      };
    };
  };
}
