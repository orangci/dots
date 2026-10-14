{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;

  cfg = config.modules.security.restic;

in
{
  options.modules.security.restic = {
    enable = mkEnableOption "restic backups";

    paths = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "/var/lib/forgejo"
        "/srv/files"
      ];
      description = "The files and directories to back up. Nothing is added automatically, so remember to add a service's data directory here when you enable it.";
    };

    repository = mkOption {
      type = types.str;
      default = "/mnt/backup";
      example = "/mnt/backup";
      description = "The restic repository to back up to. For a local repository, the backup only runs while the path is mounted.";
    };

    keepLast = mkOption {
      type = types.int;
      default = 5;
      description = "How many of the most recent snapshots to keep when pruning. Older snapshots are deleted.";
    };
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets.restic-password.path = "/var/secrets/restic-password";
    # the backup drive is mounted with nofail, so without this a missing drive
    # means restic quietly initialises a new repository on the root drive
    systemd.services.restic-backups-grand-backup.unitConfig.RequiresMountsFor =
      mkIf (lib.hasPrefix "/" cfg.repository) cfg.repository;
    services.restic.backups.grand-backup = {
      passwordFile = config.modules.security.sops.secrets.restic-password.path;
      inherit (cfg) repository paths;
      initialize = true;
      runCheck = true;
      pruneOpts = lib.singleton "--keep-last ${toString cfg.keepLast}";
    };
    services.restic.server = mkIf config.modules.services.monitoring.grafana.enable {
      enable = true;
      listenAddress = "127.0.0.1:9636";
      prometheus = true;
      privateRepos = true;
    };
  };
}
