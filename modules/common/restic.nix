{
  config,
  lib,
  pkgs,
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

    device = mkOption {
      type = types.str;
      example = "/dev/disk/by-uuid/XXXX";
      description = "Location of the device to mount to the location of the restic repository";
    };

    keepLast = mkOption {
      type = types.int;
      default = 5;
      description = "Number of snapshots (of backups) to keep";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.restic-password.path = "/var/secrets/restic-password";
    services.restic.backups.grand-backup = {
      passwordFile = config.modules.common.sops.secrets.restic-password.path;
      inherit (cfg) repository paths;
      initialize = true;
      runCheck = true;
      pruneOpts = lib.singleton "--keep-last ${toString cfg.keepLast}";
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "grand-backup" ''
        set -euo pipefail

        if [ "$EUID" -ne 0 ]; then
          echo "run as root (sudo grand-backup)"
          exit 1
        fi

        DEVICE="${cfg.device}"
        MOUNTPOINT="${cfg.repository}"

        if [ ! -e "$DEVICE" ]; then
          echo "device $DEVICE not found"
          exit 1
        fi

        echo "mounting $DEVICE → $MOUNTPOINT"

        if ! mountpoint -q "$MOUNTPOINT"; then
          mkdir -p "$MOUNTPOINT"
          mount "$DEVICE" "$MOUNTPOINT"
          mounted_here=1
        else
          mounted_here=0
        fi

        trap 'if [ "$mounted_here" = 1 ]; then umount "$MOUNTPOINT"; fi' EXIT

        echo "running restic backup..."
        systemctl start restic-backups-grand-backup.service
        systemctl status restic-backups-grand-backup.service --no-pager

        echo ""
        echo "done. ur data is (probably) safe, cousin >,>"
      '')
    ];
  };
}
