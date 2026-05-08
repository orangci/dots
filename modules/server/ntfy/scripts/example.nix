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
    mkOption
    types
    singleton
    ;
  cfg = config.modules.server.ntfy.scripts.example;
  script = pkgs.writeShellApplication {
    name = "ntfy-script-example";
    runtimeInputs = with pkgs; [ curl ];
    text = ''
      you may use $NTFY_ACCESS_TOKEN in this script to reference the ntfy access token, as well as ${cfg.topic}
    '';
  };
in
{
  options.modules.server.ntfy.scripts.example = {
    enable = mkEnableOption "Enable example script for Ntfy";
    topic = mkOption {
      type = types.str;
      default = "example";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ntfy-script-example = {
      description = "Ntfy example script";
      after = [ "ntfy-sh.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${script}/bin/ntfy-script-example";
        Restart = "always";
        RestartSec = 5;
        User = "ntfy-sh";
        EnvironmentFile = config.modules.common.sops.secrets.ntfy-access-token.path;
      };
    };
  };
}
