{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;

  cfg = config.modules.server.filebrowser;

  dataDirGenerated = pkgs.runCommand "filebrowser-data" { } ''
    mkdir -p $out
    mkdir -p $out/data
    echo '${lib.generators.toYAML { } cfg.settings}' > $out/data/config.yaml
  '';
in
{
  options.modules.server.filebrowser = {
    enable = mkEnableOption "Enable Filebrowser";

    name = mkOption {
      type = types.str;
      default = "Filebrowser";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for Filebrowser to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "filebrowser.orangc.net";
      description = "The domain for Filebrowser to be hosted at";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/filebrowser";
      description = "Host path to the folder you want to expose inside Filebrowser as /folder";
    };

    settings = mkOption {
      type = types.attrs;
      description = "Filebrowser configuration. See https://github.com/gtsteffaniak/filebrowser/wiki/Configuration-And-Examples for documentation";
      default = {
        server = {
          sources = [ { path = "/files"; } ];
          port = cfg.port;
          baseURL = "/";
        };
        frontend = {
          name = "files";
          disableDefaultLinks = true;
        };
        auth.adminUsername = username;
        integrations.media.ffmpegPath = "${pkgs.ffmpeg}/bin";
      };
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.filebrowser-env.path = "/var/secrets/filebrowser-env";

    systemd.tmpfiles.rules = [ "d ${cfg.dataDir} 0755 root root -" ];

    virtualisation.oci-containers.containers."filebrowser" = {
      image = "gtstef/filebrowser";
      ports = [ "${toString cfg.port}:${toString cfg.port}" ];
      environment = {
        FILEBROWSER_CONFIG = "data/config.yaml";
        TZ = config.time.timeZone;
      };
      environmentFiles = [ config.modules.common.sops.secrets.filebrowser-env.path ];
      volumes = [
        "${cfg.dataDir}:/data"
        "${dataDirGenerated}/data:/home/filebrowser/data"
        "/home/${username}:/files"
      ];
    };
  };
}
