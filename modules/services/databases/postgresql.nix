{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    concatMap
    mkForce
    ;
  inherit (builtins) concatStringsSep;
  cfg = config.modules.services.databases.postgresql;
in
{
  options.modules.services.databases.postgresql = {
    enable = mkEnableOption "postgresql";

    port = mkOption {
      type = types.port;
      default = 5432;
      description = "The port PostgreSQL listens on.";
    };

    databases = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "kaju" ];
      description = "The databases to create if they do not exist yet. Each one is accessible without a password, over the local socket, to every user in `users`.";
    };

    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "kaju" ];
      description = "The users to create if they do not exist yet. A user becomes the owner of the database with the same name, if there is one.";
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
        )}
        ${concatStringsSep "\n" (
          concatMap (db: map (user: "host ${db} ${user} 100.64.0.0/10 trust") cfg.users) cfg.databases
        )}
        ${concatStringsSep "\n" (
          concatMap (db: map (user: "host ${db} ${user} fd7a:115c:a1e0::/48 trust") cfg.users) cfg.databases
        )}
        ${concatStringsSep "\n" (
          concatMap (db: map (user: "host ${db} ${user} 192.168.0.0/16 trust") cfg.users) cfg.databases
        )}
      ''; # 10.88.x is for podman containers, 10.64.x.x is for tailscale, and 192.168.x.x is LAN

    };
  };
}
