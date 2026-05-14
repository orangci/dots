{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.immich;
in
{
  options.modules.server.immich = lib.my.mkServerModule {
    name = "Immich";
    subdomain = "media";
  };

  config = mkIf cfg.enable {
    services.immich = {
      enable = true;
      inherit (cfg) port;
    };
  };
}
