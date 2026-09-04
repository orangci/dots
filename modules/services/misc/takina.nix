{
  config,
  lib,
  inputs,
  flakeSettings,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf singleton mkEnableOption;
  cfg = config.modules.services.misc.takina;
in
{
  imports = singleton inputs.takina.nixosModules.default;
  options.modules.services.misc.takina = {
    enable = mkEnableOption "Takina Discord bot";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets.takina-env.path = "/var/secrets/takina-env";
    services.takina = {
      enable = true;
      environmentFile = config.modules.security.sops.secrets.takina-env.path;
      config = {
        PREFIX = ".";
        EMBED_COLOUR = "#FAB387";
        LIBRETRANSLATE_API_URL = "https://${config.modules.services.tools.libretranslate.subdomain}.${flakeSettings.domains.primary}";
        EMOJIS_MODERATOR = "<:salute:1293115316506722365>";
        EMOJIS_NOTE = "<:note:1293115357220831294>";
        BOT_STATUS = "ROLLING BETA 2.0.0!!!";
        COGS_BLACKLIST = "core.settings";
        ENABLE_SESP_COGS = "yes";
      };
    };
    systemd.services.takina-postgres-backup = {
      description = "Backup Takina PostgreSQL database";
      after = [ "postgresql.service" ];
      wants = [ "postgresql.service" ];

      serviceConfig = {
        Type = "oneshot";
        User = "postgres";

        ExecStart = pkgs.writeShellScript "takina-postgres-backup" ''
          set -euo pipefail

          backup_dir="/var/backups/takina"
          timestamp="$(date '+%Y-%m-%d_%H-%M-%S')"
          backup="$backup_dir/takina-$timestamp.dump"

          mkdir -p "$backup_dir"

          ${pkgs.postgresql}/bin/pg_dump \
            --format=custom \
            --dbname=takina \
            --file="$backup"

          # Keep the last 7 backups
          find "$backup_dir" \
            -type f \
            -name 'takina-*.dump' \
            -printf '%T@ %p\n' |
            sort -nr |
            tail -n +8 |
            cut -d' ' -f2- |
            xargs -r rm --

          echo "Created backup: $backup"
        '';
      };
    };

    systemd.timers.takina-postgres-backup = {
      description = "Daily Takina PostgreSQL backup";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "30min";
      };
    };
  };
}
