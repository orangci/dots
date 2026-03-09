{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    singleton
    ;
  cfg = config.modules.server.ntfy.scripts.services;
  topicsOptions = import ../topicsOptions.nix { inherit config lib; };

  servers = builtins.attrNames config.modules.server;
  monitoredModules = builtins.filter (
    srv:
    let
      mod = config.modules.server.${srv};
    in
    (mod ? enable && mod.enable)
    && lib.hasAttrByPath [ "ntfyChecking" "enable" ] mod
    && mod.ntfyChecking.enable
    && mod ? domain
    && mod.domain != null
    && mod ? port
    && mod.port != null
  ) servers;

  pairs = builtins.map (
    srv:
    let
      mod = config.modules.server.${srv};
    in
    "\"${mod.name}|http://localhost:${toString mod.port}\""
  ) monitoredModules;

  pairsString = builtins.concatStringsSep " " pairs;

  script = pkgs.writeShellApplication {
    name = "ntfy-script-services";
    runtimeInputs = with pkgs; [ curl ];
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      pairs=(${pairsString})
      declare -A failure_counts
      declare -A notified_flags

      notify_down() {
        local name="$1"
        curl -d "$name is down!" -H "p: low" -u :"$NTFY_ACCESS_TOKEN" https://ntfy.orangc.net/${cfg.topic}
      }

      notify_up() {
        local name="$1"
        curl -d "$name is back online!" -H "p: low" -u :"$NTFY_ACCESS_TOKEN" https://ntfy.orangc.net/${cfg.topic}
      }

      check_domain() {
        local domain="$1"
        if curl -sf --connect-timeout 5 "$domain" > /dev/null; then
          return 0
        else
          return 1
        fi
      }

      while true; do
        for pair in "''${pairs[@]}"; do
          name="''${pair%%|*}"
          domain="''${pair#*|}"

          if check_domain "$domain"; then
            if [ "''${notified_flags[$name]:-0}" -eq 1 ]; then
              notify_up "$name"
            fi
            failure_counts[$name]=0
            notified_flags[$name]=0
          else
            failure_counts[$name]=$(( ''${failure_counts[$name]:-0} + 1 ))
            if [ "''${failure_counts[$name]}" -ge 3 ] && [ "''${notified_flags[$name]:-0}" -ne 1 ]; then
              notify_down "$name"
              notified_flags[$name]=1
            fi
          fi
        done
        sleep 5m
      done
    '';
  };
in
{
  options.modules.server.ntfy.scripts.services = {
    enable = mkEnableOption "Enable services script for Ntfy";
    inherit (topicsOptions) users;
    topic = topicsOptions.topic // {
      default = "services";
    };
    permission = topicsOptions.permission // {
      default = "read-only";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = singleton script;
    modules.server.ntfy.topics = singleton {
      name = cfg.topic;
      inherit (cfg) users;
      inherit (cfg) permission;
    };
    systemd.services.ntfy-script-services = {
      description = "Ntfy services script";
      after = [ "ntfy-sh.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${script}/bin/ntfy-script-services";
        Restart = "always";
        RestartSec = 5;
        User = "ntfy-sh";
        EnvironmentFile = config.modules.common.sops.secrets.ntfy-access-token.path;
      };
    };
  };
}
