{
  config,
  lib,
  host,
  pkgs,
  flakeSettings,
  ...
}:
let
  inherit (lib) singleton mkIf;
  cfg = config.modules.server.forgejo;
in
{
  imports = singleton ./renovate.nix;
  options.modules.server.forgejo = lib.my.mkServerModule {
    name = "Forgejo";
    subdomain = "git";
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
        service.DISABLE_REGISTRATION = true; # set to true after the first run
        time.DEFAULT_UI_LOCATION = config.time.timeZone;
        badges.GENERATOR_URL_TEMPLATE = "https://img.shields.io/badge/{{.label}}-{{.text}}-{{.color}}?style=for-the-badge";
        server = {
          ROOT_URL = "https://${cfg.subdomain}.${flakeSettings.domains.primary}/";
          DOMAIN = "https://${cfg.subdomain}.${flakeSettings.domains.primary}/";
          HTTP_PORT = cfg.port;
          PROTOCOL = "http";
          LANDING_PAGE = "explore";
        };
        repository = {
          PREFERRED_LICENSES = "AGPL-3.0,GPL-3.0,ISC,CC-BY-SA-4.0,BSD-3-Clause,Unlicense";
          DISABLE_STARS = true;
          DEFAULT_BRANCH = "master";
          DEFAULT_REPO_UNITS = "repo.code,repo.issues,repo.pulls,repo.actions";
        };
        "repository.pull-request" = {
          DEFAULT_MERGE_STYLE = "rebase";
          DEFAULT_UPDATE_STYLE = "rebase";
        };
        ui = {
          DEFAULT_THEME = "catppuccin-peach-auto";
          THEMES = "catppuccin-mocha-rosewater,catppuccin-mocha-flamingo,catppuccin-mocha-pink,catppuccin-mocha-mauve,catppuccin-mocha-red,catppuccin-mocha-maroon,catppuccin-mocha-peach,catppuccin-mocha-yellow,catppuccin-mocha-green,catppuccin-mocha-teal,catppuccin-mocha-sky,catppuccin-mocha-sapphire,catppuccin-mocha-blue,catppuccin-mocha-lavender,catppuccin-rosewater-auto,catppuccin-flamingo-auto,catppuccin-pink-auto,catppuccin-mauve-auto,catppuccin-red-auto,catppuccin-maroon-auto,catppuccin-peach-auto,catppuccin-yellow-auto,catppuccin-green-auto,catppuccin-teal-auto,catppuccin-sky-auto,catppuccin-sapphire-auto,catppuccin-blue-auto,catppuccin-lavender-auto,forgejo-auto";
        };
        "ui.meta" = {
          AUTHOR = flakeSettings.username;
          DESCRIPTION = "${flakeSettings.username}'s selfhosted instance of forgejo";
        };
      };
    };
    modules.common.sops.secrets.forgejo-runner-registration-token.path =
      "/var/secrets/forgejo-runner-registration-token";

    virtualisation.docker.enable = true;
    services.gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances.forgejo = {
        enable = true;
        name = host;
        url = "https://${cfg.subdomain}.${flakeSettings.domains.tailnet}";
        tokenFile = config.modules.common.sops.secrets.forgejo-runner-registration-token.path;
        # hostPackages =
        labels = [
          "ubuntu-latest:docker://william/action-runners:ubuntu-24.04"
          "ubuntu-24.04:docker://william/action-runners:ubuntu-24.04"
          "ubuntu-22.04:docker://william/action-runners:ubuntu-22.04"
          "nixos-latest:docker://nixos/nix"
        ];
        settings = {
          container = {
            network = "host";
            docker_host = "unix:///run/docker.sock";
          };
          runner = {
            capacity = 5;
            labels = [
              "ubuntu-latest:docker://william/action-runners:ubuntu-24.04"
              "ubuntu-24.04:docker://william/action-runners:ubuntu-24.04"
              "ubuntu-22.04:docker://william/action-runners:ubuntu-22.04"
              "nixos-latest:docker://nixos/nix"
            ];
          };
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
      lib.mkAfter ''
        rm -rf ${config.services.forgejo.stateDir}/custom/public/assets
        mkdir -p ${config.services.forgejo.stateDir}/custom/public/assets/css
        cp -r --no-preserve=mode,ownership ${theme}/* ${config.services.forgejo.stateDir}/custom/public/assets/css
        mkdir -p ${config.services.forgejo.stateDir}/custom/public/assets/img
        cp -r --no-preserve=mode,ownership ${./public/assets/img}/* ${config.services.forgejo.stateDir}/custom/public/assets/img
      '';
  };
}
