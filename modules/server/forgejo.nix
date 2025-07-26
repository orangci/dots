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
  cfg = config.modules.server.forgejo;
in
{
  options.modules.server.forgejo = {
    enable = mkEnableOption "Enable forgejo";

    name = mkOption {
      type = types.str;
      default = "forgejo";
    };

    domain = mkOption {
      type = types.str;
      default = "git.orangc.net";
      description = "The domain for forgejo to be hosted at";
    };
    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for forgejo to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      package = pkgs.forgejo;
      dump = {
        # Backup configuration
        enable = true;
        type = "tar.gz";
        file = "forgejo-backup"; # Filename
        # Interval uses this specification: https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
        interval = "weekly";
      };

      settings = {
        DEFAULT.APP_NAME = "forgejo";
        session.COOKIE_SECURE = true;
        service.DISABLE_REGISTRATION = false; # set to true after the first run
        time.DEFAULT_UI_LOCATION = config.time.timeZone;
        server = {
          ROOT_URL = "https://${cfg.domain}/";
          DOMAIN = "https://${cfg.domain}/";
          HTTP_PORT = cfg.port;
          PROTOCOL = "http";
          LANDING_PAGE = "explore";
        };
        repository = {
          PREFERRED_LICENSES = "AGPL-3.0,GPL-3.0,ISC,CC-BY-SA-4.0,BSD-3-Clause,Unlicense";
          DISABLE_STARS = true;
          DEFAULT_BRANCH = "master";
        };
        ui = {
          DEFAULT_THEME = "catppuccin-peach-auto";
          THEMES = "catppuccin-mocha-rosewater,catppuccin-mocha-flamingo,catppuccin-mocha-pink,catppuccin-mocha-mauve,catppuccin-mocha-red,catppuccin-mocha-maroon,catppuccin-mocha-peach,catppuccin-mocha-yellow,catppuccin-mocha-green,catppuccin-mocha-teal,catppuccin-mocha-sky,catppuccin-mocha-sapphire,catppuccin-mocha-blue,catppuccin-mocha-lavender,catppuccin-rosewater-auto,catppuccin-flamingo-auto,catppuccin-pink-auto,catppuccin-mauve-auto,catppuccin-red-auto,catppuccin-maroon-auto,catppuccin-peach-auto,catppuccin-yellow-auto,catppuccin-green-auto,catppuccin-teal-auto,catppuccin-sky-auto,catppuccin-sapphire-auto,catppuccin-blue-auto,catppuccin-lavender-auto,forgejo-auto";
        };
        "ui.meta" = {
          AUTHOR = "orangc";
          DESCRIPTION = "orangc's selfhosted instance of forgejo";
        };
      };
    };
    systemd.services.forgejo.preStart =
      let
        theme = pkgs.fetchzip {
          url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
          sha256 = "sha256-rZHLORwLUfIFcB6K9yhrzr+UwdPNQVSadsw6rg8Q7gs=";
          stripRoot = false;
        };
      in
      builtins.concatStringsSep [
        config.systemd.services.forgejo.preStart
        ''
          rm -rf ${config.services.forgejo.stateDir}/custom/public/assets
          mkdir -p ${config.services.forgejo.stateDir}/custom/public/assets
          ln -sf ${theme} ${config.services.forgejo.stateDir}/custom/public/assets/css
          ln -sf ${./gitea/public/assets/img} ${config.services.forgejo.stateDir}/custom/public/assets/img
          rm -rf ${config.services.forgejo.stateDir}/custom/templates
        ''
      ];
  };
}
