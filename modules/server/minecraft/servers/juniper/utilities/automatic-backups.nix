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
    getExe
    mkOption
    types
    mkEnableOption
    ;
  cfg = config.modules.server.minecraft.juniper-s10.automatic-backups;
  script = pkgs.writeShellScriptBin "juniper-rcon-backup" ''
    function rcon {
        ${lib.getExe pkgs.rconc} jp "$1"
    }

    export PATH="$PATH:${pkgs.gzip}/bin/"

    rcon 'say [§4WARNING§r] The Server will back itself up in five minutes.'
    sleep 5m

    rcon 'say [§4WARNING§r] The Server backup process is starting §bNOW§r. Prepare for some lag...'

    rcon 'chunky trim world square 0 0 0 0 outside 0'
    rcon 'chunky confirm'
    rcon 'chunky trim world_the_nether square 0 0 0 0 outside 0'
    rcon 'chunky confirm'
    rcon 'chunky trim world_the_end square 0 0 0 0 outside 0'
    rcon 'chunky confirm'

    rcon "save-off"
    rcon "save-all"
    ${lib.getExe pkgs.gnutar} -cvpzf ~/backups/juniper/backup-$(date +%F).tar.gz ~/juniper/world
    rcon "save-on"

    rcon 'say [§bNOTICE§r] The Server backup process has completed.'

    # Delete older backups
    find ~/backups/juniper -type f -mtime +7 -name 'backup-*.tar.gz' -delete
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
    systemd.services.juniper-automatic-backups = {
      enable = true;
      description = "Prune chunks and backup Juniper world folder to backup folder";
      serviceConfig = {
        User = "minecraft";
        Type = "oneshot";
        ExecStart = "${script}/bin/juniper-rcon-backup";
      };
    };
    systemd.timers.juniper-automatic-backups = {
      description = "Timer to regularly prune chunks of and backup Juniper";
      enable = true;
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.frequency;
        Persistent = true;
      };
    };
  };
}
