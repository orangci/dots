{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    singleton
    flatten
    ;
  cfg = config.modules.server.postgresql;
in
{
  options.modules.server.postgresql = {
    enable = mkEnableOption "Enable postgresql";

    port = mkOption {
      type = types.port;
      default = 5432;
      description = "The port for postgresql to be hosted at";
    };

    databases = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Names of database to ensure exist in PostgreSQL.";
    };

    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Names of users to ensure exist in PostgreSQL.";
    };
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      settings.port = cfg.port;
      ensureDatabases = cfg.databases;
      ensureUsers = map (name: {
        inherit name;
        ensureDBOwnership = true;
      }) cfg.users;

      authentication = builtins.concatStringsSep "\n" (
        flatten (
          map (
            db: map (user: builtins.concatStringsSep "\n" singleton "local ${db} ${user.name} trust") cfg.users
          ) cfg.databases
        )
      );
    };
  };
}
