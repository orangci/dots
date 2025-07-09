# This file was modified from Rexcrazy804's backup script
# https://github.com/Rexcrazy804/Zaphkiel/blob/master/nixosModules/server/minecraft/backupservice.nix
# Ty Rexi
{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf getExe;
  cfg = config.modules.server.minecraft.juniper-s10;
  script = pkgs.writeShellScriptBin "chunky-pruner" ''
    function rcon {
        ${getExe pkgs.rconc} jp "$1"
    }

    rcon 'say [§4WARNING§r] In five minutes, the server will begin pruning unused chunks across all dimensions to save disk space.'
    sleep 5m

    rcon 'say [§4WARNING§r] Server chunk pruning process is starting NOW. There might be some slight lag.'

    rcon 'chunky trim world square 0 0 0 0 outside 0'
    rcon 'chunky confirm'
    rcon 'chunky trim world_the_nether square 0 0 0 0 outside 0'
    rcon 'chunky confirm'
    rcon 'chunky trim world_the_end square 0 0 0 0 outside 0'
    rcon 'chunky confirm'

    rcon 'say [§bNOTICE§r] Server chunk pruning process is complete.'
  '';
in
{
  config = mkIf cfg.chunky-pruner.enable {
    systemd.services.chunky-pruner = {
      enable = true;
      description = "Regularly prune Juniper's chunks";
      serviceConfig = {
        User = "minecraft";
        Type = "oneshot";
        ExecStart = "${script}/bin/chunky-pruner";
      };
    };
    systemd.timers.chunky-pruner = {
      description = "Timer to regularly prune Juniper's chunks";
      enable = true;
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };
  };
}
