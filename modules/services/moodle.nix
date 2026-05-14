{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.moodle;
in
{
  options.modules.server.moodle = lib.my.mkServerModule { name = "Moodle"; };

  config = mkIf cfg.enable {
    services.moodle = {
      enable = true;
      initialPassword = "admin";
      database.port = cfg.port - 1000;
      virtualHost = {
        adminAddr = "moodle@${flakeSettings.domains.email}";
        hostName = "127.0.0.1";
        listen = lib.singleton {
          ip = "*";
          inherit (cfg) port;
        };
      };
    };
  };
}
