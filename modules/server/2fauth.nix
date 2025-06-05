{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.twofauth;
in
{
  options.modules.server.twofauth = {
    enable = mkEnableOption "Enable 2fauth";

    port = mkOption {
      type = types.port;
      default = 8000;
      description = "The port for 2FAuth to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "2fauth.orangc.net";
      description = "The domain for 2FAuth to be hosted at";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/2fauth";
      description = "Directory to persist 2fauth configuration and data";
    };
  };

  config = mkIf cfg.enable {
    users.users.twofauth = {
      isSystemUser = true;
      uid = 1000;
      group = "2fauth";
    };

    users.groups.twofauth = { };

    virtualisation.oci-containers.containers.twofauth = {
      image = "2fauth/2fauth:latest";
      autoStart = true;
      ports = [ "127.0.0.1:${toString cfg.port}:8000/tcp" ];
      volumes = [ "${cfg.dataDir}:/2fauth" ];
      user = "1000:1000";
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0700 2fauth 2fauth -"
    ];

    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
