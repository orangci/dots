{
  config,
  lib,
  pkgs,
  host,
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
  cfg = config.modules.server.ntfy.scripts.power-on;
  topicsOptions = import ../topicsOptions.nix { inherit config lib; };
  script = pkgs.writeShellApplication {
    name = "ntfy-script-power-on";
    runtimeInputs = with pkgs; [ curl ];
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      curl -s -d "✅ ${host} has powered on at $(date +"%B %d, %H.%M")." -u :"$NTFY_ACCESS_TOKEN" https://ntfy.orangc.net/${cfg.topic}
    '';
  };
in
{
  options.modules.server.ntfy.scripts.power-on = {
    enable = mkEnableOption "Enable power-on script for Ntfy";
    users = topicsOptions.users;
    topic = topicsOptions.topic // {
      default = "power-on";
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
    systemd.services.ntfy-script-power-on = {
      description = "Ntfy power-on script";
      after = [ "ntfy-sh.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${script}/bin/ntfy-script-power-on";
        User = "ntfy-sh";
        EnvironmentFile = config.modules.common.sops.secrets.ntfy-access-token.path;
      };
    };
  };
}
