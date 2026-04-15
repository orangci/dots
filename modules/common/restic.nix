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

  cfg = config.modules.common.restic;

in
{
  options.modules.common.restic = {
    enable = mkEnableOption "Enable restic backups";

    paths = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Paths to files/folders to backup";
    };

    repository = mkOption {
      type = types.str;
      default = "/mnt/backup";
      description = "Location of the restic repository to backup to";
    };

    keepLast = mkOption {
      type = types.int;
      default = 5;
      description = "Number of snapshots (of backups) to keep";
    };
  };

  config = mkIf cfg.enable {
    # important: before enabling this module, mount the HDD first!!
    modules.common.sops.secrets.restic-password.path = "/var/secrets/restic-password";
    services.restic.backups.grand-backup = {
      passwordFile = config.modules.common.sops.secrets.restic-password.path;
      inherit (cfg) repository paths;
      initialize = true;
      runCheck = true;
      pruneOpts = lib.singleton "--keep-last ${toString cfg.keepLast}";
    };
    services.restic.server = mkIf config.modules.server.grafana.enable {
      enable = true;
      listenAddress = "127.0.0.1:9636";
      prometheus = true;
      privateRepos = true;
    };
  };
}
