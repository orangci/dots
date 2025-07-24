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
      type = types.port;
      default = 8800;
      description = "The port for gitea to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.gitea = {
      enable = true;
      appName = "gitea";
      dump = {
        # Backup configuration
        enable = true;
        type = "tar.gz";
        file = "gitea-backup"; # Filename
        # Interval uses this specification: https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
        interval = "weekly";
      };

      settings = {
        session.COOKIE_SECURE = true;
        service.DISABLE_REGISTRATION = true; # set to true after the first run
        server = {
          ROOT_URL = "https://${cfg.domain}/";
          DOMAIN = "https://${cfg.domain}/";
          HTTP_PORT = cfg.port;
          PROTOCOL = "http";
        };
        repository = {
          PREFERRED_LICENSES = "AGPL-3.0,GPL-3.0,ISC,CC-BY-SA-4.0,BSD-3-Clause,Unlicense";
          DISABLE_STARS = true;
          DEFAULT_BRANCH = "master";
        };
        ui = {
          DEFAULT_THEME = "catppuccin-mocha-mauve";
          THEMES = "catppuccin-mocha-rosewater,catppuccin-mocha-flamingo,catppuccin-mocha-pink,catppuccin-mocha-mauve,catppuccin-mocha-red,catppuccin-mocha-maroon,catppuccin-mocha-peach,catppuccin-mocha-yellow,catppuccin-mocha-green,catppuccin-mocha-teal,catppuccin-mocha-sky,catppuccin-mocha-sapphire,catppuccin-mocha-blue,catppuccin-mocha-lavender,catppuccin-rosewater-auto,catppuccin-flamingo-auto,catppuccin-pink-auto,catppuccin-mauve-auto,catppuccin-red-auto,catppuccin-maroon-auto,catppuccin-peach-auto,catppuccin-yellow-auto,catppuccin-green-auto,catppuccin-teal-auto,catppuccin-sky-auto,catppuccin-sapphire-auto,catppuccin-blue-auto,catppuccin-lavender-auto,gitea-auto";
        };
        "ui.meta" = {
          AUTHOR = "gitea";
          DESCRIPTION = "orangc's selfhosted instance of gitea";
        };
      };
    };
    systemd.services.gitea.preStart =
      let
        theme = pkgs.fetchzip {
          url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
          sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          stripRoot = false;
        };
      in
      ''
        rm -rf ${config.services.gitea.stateDir}/custom/public/assets
        mkdir -p ${config.services.gitea.stateDir}/custom/public/assets
        ln -sf ${theme} ${config.services.gitea.stateDir}/custom/public/assets/css
      '';
  };
}
