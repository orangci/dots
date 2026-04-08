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
    modules.common.sops.secrets."nixflix/prowlarr/apiKey".path = "/var/secrets/nixflix-prowlarr-apiKey";
    nixflix.prowlarr = {
      enable = true;
      config.apiKey._secret = config.modules.common.sops.secrets."nixflix/prowlarr/apiKey".path;
      settings.server.port = 0;
    };
  };
}
