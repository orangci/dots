{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.services.media.jellyfin;
in
{
  options.modules.services.media.jellyfin = lib.my.mkServerModule {
    name = "Jellyfin";
    subdomain = "jf";
  };

  config = mkIf cfg.enable {
    services.jellyfin.enable = true;
  };
}
