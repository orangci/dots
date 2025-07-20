# This is my modified version Rexcrazy804's backup script
# https://github.com/Rexcrazy804/Zaphkiel/blob/master/nixosModules/server/minecraft/backupservice.nix
# Ty Rexi
{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    getExe
    ;

  cfg = config.modules.server.minecraft.juniper-s10.automatic-backups;

  script = pkgs.writeShellScriptBin "juniper-rcon-backup" ''
    function rcon {
        ${getExe pkgs.rconc} jp "$1"
    }

    BACKUP_DIR=~/backups/juniper-s10
    SNAPSHOT_DIR=$BACKUP_DIR/$(date +%F)
    mkdir -p "$BACKUP_DIR"

    rcon 'say [§4WARNING§r] The Server will back itself up in five minutes.'
    # sleep 5m

    rcon 'say [§4WARNING§r] The Server backup process is starting §bNOW§r. Prepare for some lag...'

    rcon "save-off"

    rcon 'chunky trim overworld square 0 0 0 0 outside 0'
    rcon 'chunky confirm'
    rcon 'chunky trim the_nether square 0 0 0 0 outside 0'
    rcon 'chunky confirm'
    rcon 'chunky trim the_end square 0 0 0 0 outside 0'
    rcon 'chunky confirm'

    mkdir -p "$(dirname "$SNAPSHOT_DIR")"
    ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot ~/juniper/world "$SNAPSHOT_DIR"

    rcon "save-all"
    rcon "save-on"

    rcon 'say [§bNOTICE§r] The Server backup process has completed.'

    find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec ${pkgs.btrfs-progs}/bin/btrfs subvolume delete {} \; 2>/dev/null || true
  '';

  ensureSubvolScript = pkgs.writeShellScriptBin "ensure-juniper-subvol" ''
    WORLD_DIR=~/juniper/world
    mkdir -p ~/juniper/world.old
    if ! ${pkgs.btrfs-progs}/bin/btrfs subvolume show "$WORLD_DIR" > /dev/null 2>&1; then
      mv "$WORLD_DIR" ~/juniper/world.old
      ${pkgs.btrfs-progs}/bin/btrfs subvolume create "$WORLD_DIR"
      cp -aT ~/juniper/world.old "$WORLD_DIR"
      rm -rf ~/juniper/world.old
    fi
  '';
in
{
  options.modules.server.minecraft.juniper-s10.automatic-backups = {
    enable = mkEnableOption "Automatically backup and prune the server";
    frequency = mkOption {
      type = types.str;
      default = "daily";
      description = "The frequency of which to perform backups and prunes";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ensure-juniper-subvolume = {
      enable = true;
      description = "Ensure Juniper world folder is a btrfs subvolume";
      before = [ "juniper-automatic-backups.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "minecraft";
        Type = "oneshot";
        ExecStart = "${ensureSubvolScript}/bin/ensure-juniper-subvol";
      };
    };

    systemd.services.juniper-automatic-backups = {
      enable = true;
      description = "Prune chunks and backup Juniper world folder to backup folder";
      after = [ "ensure-juniper-subvolume.service" ];
      serviceConfig = {
        User = "minecraft";
        Type = "oneshot";
        ExecStart = "${script}/bin/juniper-rcon-backup";
      };
    };

    systemd.timers.juniper-automatic-backups = {
      enable = true;
      description = "Timer to regularly prune chunks and backup Juniper";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.frequency;
        Persistent = true;
      };
    };
  };
}
