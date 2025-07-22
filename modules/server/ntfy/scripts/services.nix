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
  script = pkgs.writeShellApplication {
    name = "ntfy-script-services";
    runtimeInputs = with pkgs; [ curl ];
    text = ''
      curl -d "Memories of Phantasm" -u :"$NTFY_ACCESS_TOKEN" https://ntfy.orangc.net/services
      sleep 10000000000
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
    systemd.services.ntfy-services-script = {
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
