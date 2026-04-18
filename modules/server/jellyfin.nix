{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.jellyfin;
in
{
  options.modules.server.jellyfin = lib.my.mkServerModule {
    name = "Jellyfin";
    subdomain = "jf";
  };

  config = mkIf cfg.enable {
    services.jellyfin.enable = true;
  };
}
