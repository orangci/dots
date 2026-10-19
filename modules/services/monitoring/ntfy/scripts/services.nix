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
  cfg = config.modules.services.monitoring.ntfy.scripts.services;

  ntfyUrl = "https://${ntfy.subdomain}.${flakeSettings.domains.primary}/${cfg.topic}";
  ntfy = config.modules.services.monitoring.ntfy;

  # modules live at modules.services.<category>.<name>
  monitoredModules = lib.concatMapAttrs (
    _: lib.filterAttrs (_: mod: mod.enable or false && mod.ntfyChecking.enable or false && mod ? port)
  ) config.modules.services;

  pairs = lib.mapAttrsToList (
    _: mod: lib.escapeShellArg "${mod.name}|http://localhost:${toString mod.port}"
  ) monitoredModules;

  pairsString = builtins.concatStringsSep " " pairs;

  script = pkgs.writeShellApplication {
    name = "ntfy-script-services";
    runtimeInputs = with pkgs; [
      curl
      ntfy-sh
    ];
    text = ''
      pairs=(${pairsString})
      declare -A failure_counts
      declare -A notified_flags

      # the ntfy-access-token secret holds NTFY_ACCESS_TOKEN=...
      token="''${NTFY_ACCESS_TOKEN:-''${NTFY_TOKEN:-}}"

      # a failed notification shouldn't kill the loop and lose its state
      notify() {
        ntfy publish --quiet --priority low --token "$token" ${ntfyUrl} "$1" || true
      }

      notify_down() {
        notify "$1 is down!"
      }

      notify_up() {
        notify "$1 is back online!"
      }

      check_domain() {
        local domain="$1"
        # any HTTP answer counts as up, some services reply 401/404 at /
        if curl -s -o /dev/null --connect-timeout 5 --max-time 15 "$domain"; then
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
  options.modules.services.monitoring.ntfy.scripts.services = {
    enable = mkEnableOption "services script for Ntfy";
    topic = mkOption {
      type = types.str;
      default = "services";
      description = "The ntfy topic that down and back-online notifications are published to. It is readable by everyone, see the `acl` option of the ntfy module.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = singleton script;
    modules.services.monitoring.ntfy.acl = singleton "*:${cfg.topic}:read";
    systemd.services.ntfy-script-services = {
      description = "Ntfy services script";
      after = [ "ntfy-sh.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${script}/bin/ntfy-script-services";
        Restart = "always";
        RestartSec = 5;
        User = "ntfy-sh";
        EnvironmentFile = config.modules.security.sops.secrets.ntfy-access-token.path;
      };
    };
  };
}
