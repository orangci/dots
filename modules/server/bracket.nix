{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;

  cfg = config.modules.server.bracket;

  bracketSrc = pkgs.fetchFromGitHub {
    owner = "evroon";
    repo = "bracket";
    rev = "..."; # TODO
    sha256 = "sha256-..."; # TODO
  };
in
{
  options.modules.server.bracket = {
    enable = mkEnableOption "Enable Bracket";

    domain = mkOption {
      type = types.str;
      default = "bracket.orangc.net";
      description = "The domain for bracket to be hosted at";
    };

    port = mkOption {
      type = types.port;
      default = 8815;
      description = "The port for bracket to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    users.users.bracket = {
      isSystemUser = true;
      home = "/var/lib/bracket";
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "bracket" ];
      ensureUsers = [
        {
          name = "bracket";
          ensureDBOwnership = true;
        }
      ];
    };

    system.activationScripts.bracket-init = ''
      if [ ! -f /var/lib/bracket/.setup-complete ]; then
        echo "Setting up Bracket..."
        mkdir -p /var/lib/bracket
        cp -r ${bracketSrc}/* /var/lib/bracket/
        chown -R bracket:bracket /var/lib/bracket
        touch /var/lib/bracket/.setup-complete
      fi
    '';

    systemd.services.bracket-backend = {
      description = "Bracket backend";
      after = [
        "network.target"
        "syslog.target"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "bracket";
        WorkingDirectory = "/var/lib/bracket/backend";
        ExecStart = "${pkgs.pipenv}/bin/pipenv run gunicorn -k uvicorn.workers.UvicornWorker bracket.app:app --bind localhost:${toString (cfg.port - 1000)} --workers 1";
        # EnvironmentFile = ; TODO
        TimeoutSec = 15;
        Restart = "always";
        RestartSec = "2s";
      };
    };

    systemd.services.bracket-frontend = {
      description = "Bracket frontend";
      after = [
        "network.target"
        "syslog.target"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "bracket";
        WorkingDirectory = "/var/lib/bracket/frontend";
        ExecStart = "${pkgs.nodePackages.yarn}/bin/yarn start";
        # EnvironmentFile = ; TODO
        TimeoutSec = 15;
        Restart = "always";
        RestartSec = "2s";
      };
    };

    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
