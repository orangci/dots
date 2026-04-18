{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.uptime-kuma;
in
{
  options.modules.server.uptime-kuma = lib.my.mkServerModule {
    name = "Uptime Kuma";
    subdomain = "status";
  };

  config = mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
      settings.PORT = toString cfg.port;
    };
  };
}
