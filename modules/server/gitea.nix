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
        file = "backup"; # Filename
        # Interval uses this specification: https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
        interval = "weekly";
      };

      settings = {
        session.COOKIE_SECURE = true;
        service.DISABLE_REGISTRATION = true; # set to true after the first run
        ui.DEFAULT_THEME = "catppuccin-mocha-mauve";
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
    systemd.services.catppuccin-gitea-theme = {
      description = "Install Catppuccin theme for Gitea";
      wantedBy = [ "multi-user.target" ];
      after = [ "gitea.service" ];
      User = "gitea";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "install-catppuccin-gitea" ''
          set -e
          THEME_DIR="/var/lib/gitea/custom/public/assets/css"
          URL="https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz"
          TMP_FILE=$(mktemp)

          if [ -d "$THEME_DIR" ]; then
            echo "Theme directory already exists. Skipping download."
            exit 0
          fi

          echo "Downloading Catppuccin theme..."
          ${pkgs.curl}/bin/curl -L "$URL" -o "$TMP_FILE"
          echo "Extracting theme to $THEME_DIR..."
          mkdir -p "$THEME_DIR"
          ${pkgs.gnutar}/bin/tar -xzf "$TMP_FILE" -C "$THEME_DIR" --strip-components=1
          echo "Theme installed."
        '';
      };
    };
  };
}
