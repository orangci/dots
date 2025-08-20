{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    singleton
    ;
  cfg = config.modules.server.ntfy.scripts.cpu-temperature;
  topicsOptions = import ../topicsOptions.nix { inherit config lib; };
  script = pkgs.writeShellApplication {
    name = "ntfy-script-cpu-temperature";
    runtimeInputs = with pkgs; [
      curl
      lm_sensors
      gawk
    ];
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      OVERHEAT_THRESHOLD=85
      COOLDOWN_THRESHOLD=75
      ALERTED=0

      while true; do
        TEMP=$(sensors | awk '/Package id 0:/ { gsub(/\+|°C/, "", $4); print $4 }')

        if [ -n "$TEMP" ]; then
          TEMP_INT=$(printf "%.0f" "$TEMP")

          if [ "$TEMP_INT" -ge "$OVERHEAT_THRESHOLD" ] && [ "$ALERTED" -eq 0 ]; then
            curl -s -d "⚠️ CPU temperature is high: ''${TEMP_INT}°C" -u :"$NTFY_ACCESS_TOKEN" \
              https://ntfy.orangc.net/${cfg.topic}
            ALERTED=1
          elif [ "$TEMP_INT" -le "$COOLDOWN_THRESHOLD" ] && [ "$ALERTED" -eq 1 ]; then
            curl -s -d "✅ CPU temperature back to normal: ''${TEMP_INT}°C" -u :"$NTFY_ACCESS_TOKEN" \
              https://ntfy.orangc.net/${cfg.topic}
            ALERTED=0
          fi
        fi

        sleep 60
      done
    '';
  };
in
{
  options.modules.server.ntfy.scripts.cpu-temperature = {
    enable = mkEnableOption "Enable cpu-temperature script for Ntfy";
    users = topicsOptions.users;
    topic = topicsOptions.topic // {
      default = "cpu_temperature";
    };
    permission = topicsOptions.permission // {
      default = "read-only";
    };
  };

  config = mkIf cfg.enable {
    modules.server.ntfy.topics = singleton {
      name = cfg.topic;
      users = cfg.users;
      permission = cfg.permission;
    };
    systemd.services.ntfy-script-cpu-temperature = {
      description = "Ntfy cpu-temperature script";
      after = [ "ntfy-sh.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${script}/bin/ntfy-script-cpu-temperature";
        Restart = "always";
        RestartSec = 5;
        User = "ntfy-sh";
        EnvironmentFile = config.modules.common.sops.secrets.ntfy-access-token.path;
      };
    };
  };
}
