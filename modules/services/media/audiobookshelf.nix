{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.modules.services.media.audiobookshelf;
in
{
  options.modules.services.media.audiobookshelf = lib.my.mkServerModule {
    name = "Audiobookshelf";
    subdomain = "audio";
  };

  config = mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      inherit (cfg) port;
      host = "0.0.0.0";
    };
  };
}
