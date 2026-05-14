{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.services.media.immich;
in
{
  options.modules.services.media.immich = lib.my.mkServerModule {
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
