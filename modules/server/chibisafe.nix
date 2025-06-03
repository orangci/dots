{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.chibisafe;
in
{
  options.modules.server.chibisafe = {
    enable = mkEnableOption "Enable chibisafe";
    directory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/chibisafe";
      description = "The directory to put chibisafe stuff in";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = "https://safe.orangc.net/";
      description = "The domain for chibisafe to be hosted at";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ffmpeg
      nodejs_20
      yarn
      git
    ];

    systemd.tmpfiles.rules = [ "d ${cfg.directory} 0755 chibisafe chibisafe - -" ];

    users.users.chibisafe = {
      isSystemUser = true;
      home = cfg.directory;
      createHome = true;
      group = "chibisafe";
    };

    users.groups.chibisafe = { };

    systemd.services.chibisafe-setup = {
      description = "Initial clone and build of Chibisafe";
      before = [
        "chibisafe-backend.service"
        "chibisafe-frontend.service"
      ];
      wantedBy = [
        "chibisafe-backend.service"
        "chibisafe-frontend.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        User = "chibisafe";
        WorkingDirectory = cfg.directory;
        ConditionPathExists = "!${cfg.directory}/.built-successfully";
      };
      script = ''
        set -eux
        if [ ! -d ${cfg.directory}/.git ]; then
          git clone https://github.com/chibisafe/chibisafe.git ${cfg.directory}
        fi
        cd ${cfg.directory}
        yarn install
        yarn workspace @chibisafe/backend generate
        yarn workspace @chibisafe/backend migrate
        yarn build
        echo "BASE_API_URL=http://127.0.0.1:8000" > ./packages/next/.env
        touch ${cfg.directory}/.built-successfully
      '';
    };

    systemd.services.chibisafe-backend = {
      description = "Chibisafe backend";
      after = [
        "network.target"
        "chibisafe-setup.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "chibisafe";
        WorkingDirectory = cfg.directory;
        ExecStart = "${pkgs.yarn}/bin/yarn start:backend";
        Restart = "always";
      };
    };

    systemd.services.chibisafe-frontend = {
      description = "Chibisafe frontend";
      after = [
        "network.target"
        "chibisafe-setup.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "chibisafe";
        WorkingDirectory = cfg.directory;
        ExecStart = "${pkgs.yarn}/bin/yarn start:frontend";
        Restart = "always";
      };
    };

    services.caddy = {
      enable = true;

      virtualHosts.${cfg.domain} = {
        extraConfig = ''
          route {
            file_server * {
              root ${cfg.directory}/uploads
              pass_thru
            }

            @api path /api/*
            reverse_proxy @api http://127.0.0.1:8000 {
              header_up Host {http.reverse_proxy.upstream.hostport}
              header_up X-Real-IP {http.request.header.X-Real-IP}
            }

            @docs path /docs*
            reverse_proxy @docs http://127.0.0.1:8000 {
              header_up Host {http.reverse_proxy.upstream.hostport}
              header_up X-Real-IP {http.request.header.X-Real-IP}
            }

            reverse_proxy http://127.0.0.1:8001 {
              header_up Host {http.reverse_proxy.upstream.hostport}
              header_up X-Real-IP {http.request.header.X-Real-IP}
            }
          }
        '';
      };
    };
  };
}
