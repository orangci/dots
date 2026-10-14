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
      description = "The databases to create if they do not exist yet. Every user in `users` can reach each one without a password over the local socket or loopback, and with a password from podman containers, the tailnet and the LAN.";
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

      # local connections are trusted, anything over the network needs a password
      # 10.88.x.x is podman, 100.64.x.x and fd7a:115c:a1e0:: are tailscale, 192.168.x.x is LAN
      authentication = concatStringsSep "\n" (
        concatMap (
          db:
          concatMap (user: [
            "local ${db} ${user} trust"
            "host ${db} ${user} 127.0.0.1/32 trust"
            "host ${db} ${user} ::1/128 trust"
            "host ${db} ${user} 10.88.0.0/16 scram-sha-256"
            "host ${db} ${user} 100.64.0.0/10 scram-sha-256"
            "host ${db} ${user} fd7a:115c:a1e0::/48 scram-sha-256"
            "host ${db} ${user} 192.168.0.0/16 scram-sha-256"
          ]) cfg.users
        ) cfg.databases
      );

    };
  };
}
