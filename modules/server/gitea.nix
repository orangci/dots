{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.gitea;
in
{
  options.modules.server.gitea = {
    enable = mkEnableOption "Enable gitea";

    name = mkOption {
      type = types.str;
      default = "Gitea";
    };

    domain = mkOption {
      type = types.str;
      default = "git.orangc.net";
      description = "The domain for gitea to be hosted at";
    };
    port = mkOption {
      type = types.int;
      default = 8805;
      description = "The port for gitea to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    # TODO: https://github.com/catppuccin/gitea
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
          PROTOCOL = "http";
        };
        repository = {
          # PREFERRED_LICENSES = ""; TODO
          DISABLE_STARS = true;
          DEFAULT_BRANCH = "master";
        };
        "ui.meta" = {
          AUTHOR = "gitea";
          DESCRIPTION = "orangc's selfhosted instance of gitea";
        };
      };
    };
  };
}
