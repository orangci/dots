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
  cfg = config.modules.server.ntfy.scripts.example;
  topicsOptions = import ../topicsOptions.nix { inherit config lib; };
  script = pkgs.writeShellApplication {
    name = "ntfy-script-example";
    runtimeInputs = with pkgs; [ curl ];
    text = ''
      script content
    '';
  };
in
{
  options.modules.server.ntfy.scripts.example = {
    enable = mkEnableOption "Enable example script for Ntfy";
    users = topicsOptions.users;
    topic = topicsOptions.topic // {
      default = "example";
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
    systemd.services.ntfy-example-script = {
      description = "Ntfy example script";
      after = [ "ntfy-sh.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = script.name;
        Restart = "always";
        RestartSec = 5;
        User = "ntfy-sh";
        EnvironmentFile = config.modules.common.sops.secrets.ntfy-access-token.path;
      };
    };
  };
}
