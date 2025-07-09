# This is Rexcrazy804's backup script
# https://github.com/Rexcrazy804/Zaphkiel/blob/master/nixosModules/server/minecraft/backupservice.nix
# Ty Rexi
{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf getExe;
  cfg = config.modules.server.minecraft.juniper-s10;
  script = pkgs.writeShellScriptBin "juniper-rcon-backup" ''
    function rcon {
        ${lib.getExe pkgs.rconc} jp "$1"
    }

    export PATH="$PATH:${pkgs.gzip}/bin/"

    rcon 'say [§4WARNING§r] The Server will back itself up in five minutes.'
    sleep 5m

    rcon 'say [§4WARNING§r] The Server backup process is starting §bNOW§r.'

    rcon "save-off"
    rcon "save-all"
    ${lib.getExe pkgs.gnutar} -cvpzf ~/backups/juniper/backup-$(date +%F).tar.gz ~/juniper/world
    rcon "save-on"

    rcon 'say [§bNOTICE§r] The Server backup process has completed.'

    # Delete older backups
    find ~/backups/juniper -type f -mtime +7 -name 'backup-*.tar.gz' -delete
  '';
in {
  config = mkIf cfg.automatic-backups.enable {
    systemd.services.juniper-automatic-backups = {
      enable = true;
      description = "Backup Juniper world folder to backup folder";
      serviceConfig = {
        User = "minecraft";
        Type = "oneshot";
        ExecStart = "${script}/bin/juniper-rcon-backup";
      };
    };
    systemd.timers.juniper-automatic-backups = {
      description = "Timer to regularly backup Juniper";
      enable = true;
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
