# adapted from juniper's backup script, itself based on Rexcrazy804's
# https://github.com/Rexcrazy804/Zaphkiel/blob/master/nixosModules/server/minecraft/backupservice.nix
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
    singleton
    ;
  server = config.modules.services.gaming.minecraft.feysac;
  cfg = server.automatic-backups;
  script = pkgs.writeShellScriptBin "feysac-rcon-backup" ''
    # rcpwd comes from the rcon password environment file
    export RCONC_SERVER_PASSWORD="$rcpwd"
    function rcon {
        ${lib.getExe pkgs.rconc} "localhost:${toString (server.port + 10)}" "$1"
    }

    mkdir -p ~/backups/feysac
    rcon 'say [§4WARNING§r] The server will back itself up in five minutes.'
    sleep 5m

    rcon 'say [§4WARNING§r] The backup is starting §bNOW§r. Prepare for some lag...'
    rcon "save-off"
    rcon "save-all flush"
    ${lib.getExe pkgs.gnutar} -cpzf ~/backups/feysac/backup-$(date +%F).tar.gz -C ~/feysac world
    rcon "save-on"
    rcon 'say [§bNOTICE§r] The backup has completed.'

    find ~/backups/feysac -type f -name 'backup-*.tar.gz' -mtime +${toString cfg.keepDays} -delete
  '';
in
{
  options.modules.services.gaming.minecraft.feysac.automatic-backups = {
    enable = mkEnableOption "automatic backups and pruning of the Feysac world";
    frequency = mkOption {
      type = types.str;
      default = "weekly";
      example = "Sun *-*-* 04:00:00";
      description = "How often to back up the world, as a systemd calendar expression (see `man systemd.time`). The backup warns players five minutes before it starts.";
    };
    keepDays = mkOption {
      type = types.int;
      default = 28;
      description = "Backups older than this many days are deleted after each run.";
    };
  };

  config = mkIf (server.enable && cfg.enable) {
    systemd.services.feysac-automatic-backups = {
      description = "Back up the Feysac world";
      path = [ pkgs.gzip ];
      serviceConfig = {
        User = "minecraft";
        Type = "oneshot";
        EnvironmentFile = config.services.minecraft-servers.environmentFile;
        ExecStart = "${script}/bin/feysac-rcon-backup";
      };
    };
    systemd.timers.feysac-automatic-backups = {
      description = "Timer to regularly back up Feysac";
      wantedBy = singleton "timers.target";
      timerConfig = {
        OnCalendar = cfg.frequency;
        Persistent = true;
      };
    };
  };
}
