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
    ;
  cfg = config.modules.services.monitoring.ntfy.scripts.example;
  script = pkgs.writeShellApplication {
    name = "ntfy-script-example";
    runtimeInputs = with pkgs; [ ntfy-sh ];
    text = ''
      export NTFY_TOPIC=${cfg.topic}
    '';
  };
in
{
  options.modules.services.monitoring.ntfy.scripts.example = {
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
        EnvironmentFile = config.modules.security.sops.secrets.ntfy-access-token.path;
      };
    };
  };
}
