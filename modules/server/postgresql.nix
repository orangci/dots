{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    singleton
    ;
  cfg = config.modules.server.postgresql;
in
{
  options.modules.server.postgresql = {
    enable = mkEnableOption "Enable postgresql";

    name = mkOption {
      type = types.str;
      default = "PostgreSQL";
    };

    port = mkOption {
      type = types.port;
      default = 5432;
      description = "The port for postgresql to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      settings.port = cfg.port;
      ensureDatabases = mkIf config.modules.server.umami.enable (singleton "umami");

      ensureUsers = mkIf config.modules.server.umami.enable (singleton {
        name = "umami";
        ensureDBOwnership = true;
      });

      authentication = builtins.concatStringsSep "\n" (
        map (
          user:
          builtins.concatStringsSep "\n" ([
            "local ${user.name} ${user.name} trust"
            # "host ${user.name} ${user.name} 127.0.0.1/32 trust"
            # "host ${user.name} ${user.name} ::1/128 trust"
          ])
        ) config.services.postgresql.ensureUsers
      );
    };
  };
}
