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
  cfg = config.modules.server.ntfy.scripts.services;
  topicsOptions = import ../topicsOptions.nix { inherit config lib; };

  servers = builtins.attrNames config.modules.server;
  monitoredModules = builtins.filter (
    srv:
    let
      conf = config.modules.server.${srv};
    in
    conf.enable == true && lib.hasAttrByPath [ "domain" ] conf && conf.domain != null
  ) servers;

  domainList = builtins.map (srv: config.modules.server.${srv}.domain) monitoredModules;
  domainsString = builtins.concatStringsSep " " domainList;

  script = pkgs.writeShellApplication {
    name = "ntfy-script-services";
    runtimeInputs = with pkgs; [ curl ];
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail
      domains=(${domainsString})
      declare -A failure_counts
      declare -A notified_flags

      notify_down() {
        local domain="$1"
        curl -d "$domain is down!" -H "p: low" -u :"$NTFY_ACCESS_TOKEN" https://ntfy.orangc.net/${cfg.topic}
      }

      check_domain() {
        local domain="$1"
        if curl -sf --connect-timeout 5 "https://$domain" > /dev/null; then
          return 0
        else
          return 1
        fi
      }

      while true; do
        for domain in "''${domains[@]}"; do
          if check_domain "$domain"; then
            if [ "''${notified_flags[$domain]:-0}" -eq 1 ]; then
              curl -d "$domain is back online!" -H "p: low" -u :"$NTFY_ACCESS_TOKEN" https://ntfy.orangc.net/${cfg.topic}
            fi
            failure_counts[$domain]=0
            notified_flags[$domain]=0
          else
            failure_counts[$domain]=$(( ''${failure_counts[$domain]:-0} + 1 ))
            if [ "''${failure_counts[$domain]}" -ge 3 ] && [ "''${notified_flags[$domain]:-0}" -ne 1 ]; then
              notify_down "$domain"
              notified_flags[$domain]=1
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
    users = topicsOptions.users;
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
      users = cfg.users;
      permission = cfg.permission;
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
