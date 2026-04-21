{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.modules.server.libretranslate;
in
{
  options.modules.server.libretranslate = lib.my.mkServerModule { name = "LibreTranslate"; subdomain = "translate"; };

  config = mkIf cfg.enable {
    services.libretranslate = {
      enable = true;
      inherit (cfg) port;
      updateModels = true;
      enableApiKeys = false;
      extraArgs = {
        hide-api = true; # Hide the API request/response fields in the frontend
        metrics = true;
        batch-limit = 25; # max number of texts you can translate in a batch request
        req-limit = 20; # minutely request limit
      };
    };
  };
}
