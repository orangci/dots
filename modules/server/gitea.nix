{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.gitea;
in
{
  options.modules.server.gitea = {
    enable = mkEnableOption "Enable gitea";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "git.orangc.net";
      description = "The domain for gitea to be hosted at";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8805;
      description = "The port for gitea to be hosted at";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitea = {
      enable = true;
      appName = "gitea";
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
        service.DISABLE_REGISTRATION = false; # set to true after the first run
        server = {
          ROOT_URL = "https://${cfg.domain}/";
          DOMAIN = "https://${cfg.domain}/";
          HTTP_PORT = cfg.port;
          PROTOCOL = "https";
        };
        repository = {
          # PREFERRED_LICENSES = ""; TODO
          DEFAULT_REPO_UNITS = "repo.code repo.issues repo.pulls repo.wiki repo.actions";
          DISABLE_STARS = true;
          DEFAULT_BRANCH = "master";
        };
        "ui.meta" = {
          AUTHOR = "gitea";
          DESCRIPTION = "orangc's selfhosted instance of gitea";
        };
      };
    };
    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
