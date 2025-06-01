{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.server.gitea;
in {
  options.modules.server.gitea.enable = mkEnableOption "Enable gitea";

  config = lib.mkIf cfg.enable {
    services.gitea = {
      enable = true;
      appName = "gitea";
      useWizard = true; # You *must* disable this option after gitea has been run once.
      dump = {
        # Backup configuration
        enable = true;
        type = "tar.gz";
        file = "backup"; # Filename
        # Interval uses this specification: https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
        interval = "weekly";
      };

      settings = {
        session.COOKIE_SECURE = true;
        service.DISABLE_REGISTRATION = !config.services.gitea.useWizard;
        server = {
          ROOT_URL = "https://git.orangc.net/";
          DOMAIN = "https://git.orangc.net/";
          PROTOCOL = "https";
        };
        repository = {
          # PREFERRED_LICENSES = ""; TODO
          DEFAULT_REPO_UNITS = ["repo.code" "repo.issues" "repo.pulls" "repo.wiki" "repo.actions"];
          DISABLE_STARS = true;
          DEFAULT_BRANCH = "master";
        };
        ui = {
          meta = {
            AUTHOR = "gitea";
            DESCRIPTION = "orangc's selfhosted instance of gitea";
          };
        };
      };
    };
  };
}
