{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.services.monitoring.scrutiny;
in
{
  options.modules.services.monitoring.scrutiny = lib.my.mkServerModule {
    name = "Scrutiny";
    glanceIcon = "auto-invert sh:scrutiny";
  };

  config = mkIf cfg.enable {
    services.smartd.enable = true;
    services.scrutiny = {
      enable = true;
      # collector.enable = true; # metrics collection
      settings.web.listen.port = cfg.port;
    };
  };
}
