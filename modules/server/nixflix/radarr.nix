{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.common.sops.secrets."nixflix/radarr/apiKey".path = "/var/secrets/nixflix-radarr-apiKey";
    nixflix.radarr = {
      enable = true;
      apiKey._secret = config.modules.common.sops.secrets."nixflix/radarr/apiKey".path;
      settings.server.port = cfg.port + 4;
    };
  };
}
