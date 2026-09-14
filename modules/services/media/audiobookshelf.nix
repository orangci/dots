{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf singleton;
  cfg = config.modules.services.media.audiobookshelf;
in
{
  options.modules.services.media.audiobookshelf = lib.my.mkServerModule {
    name = "Audiobookshelf";
    subdomain = "audio";
  };

  config = mkIf cfg.enable {
    # so audiobookshelf can access copyparty directories
    users.users.audiobookshelf.extraGroups = mkIf config.modules.services.files.copyparty.enable (
      singleton "copyparty"
    );
    services.audiobookshelf = {
      enable = true;
      inherit (cfg) port;
      host = "0.0.0.0";
    };
  };
}
