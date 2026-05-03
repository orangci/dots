{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    singleton
    flatten
    concatMap
    mkForce
    ;
  inherit (builtins) concatStringsSep;
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
      settings.listen_addresses = mkForce "*";
      ensureDatabases = cfg.databases;
      ensureUsers = map (name: {
        inherit name;
        ensureDBOwnership = true;
      }) cfg.users;

      authentication = ''
        ${concatStringsSep "\n" (
          concatMap (db: map (user: "local ${db} ${user} trust") cfg.users) cfg.databases
        )}
        ${concatStringsSep "\n" (
          concatMap (db: map (user: "host ${db} ${user} 127.0.0.1/32 trust") cfg.users) cfg.databases
        )}
        ${concatStringsSep "\n" (
          concatMap (db: map (user: "host ${db} ${user} ::1/128 trust") cfg.users) cfg.databases
        )}
        ${concatStringsSep "\n" (
          concatMap (db: map (user: "host ${db} ${user} 10.88.0.0/16 trust") cfg.users) cfg.databases
        )}''; # 10.88.x is for podman containers
    };
  };
}
