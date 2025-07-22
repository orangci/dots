{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.convertx;
in
{
  options.modules.server.convertx = {
    enable = mkEnableOption "Enable convertx";

    name = mkOption {
      type = types.str;
      default = "ConvertX";
    };

    domain = mkOption {
      type = types.str;
      default = "convert.orangc.net";
      description = "The domain for convertx to be hosted at";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for convertx to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.convertx-env.path = "/var/secrets/convertx-env";
    systemd.tmpfiles.rules = [ "d /var/lib/convertx 0755 root root -" ];

    virtualisation.oci-containers.containers.convertx = {
      image = "ghcr.io/c4illin/convertx";
      ports = [ "127.0.0.1:${toString cfg.port}:3000" ];
      volumes = [ "/var/lib/convertx:/app/data" ];
      environmentFiles = [ "/var/secrets/convertx-env" ];
    };
  };
}
